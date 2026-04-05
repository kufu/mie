import { Controller } from '@hotwired/stimulus'

let googleMapsPromise

async function loadGoogleMaps(apiKey) {
  if (window.google?.maps?.importLibrary) {
    const { Map, InfoWindow, LatLngBounds } = await google.maps.importLibrary('maps')
    const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary('marker')

    return { Map, InfoWindow, LatLngBounds, AdvancedMarkerElement, PinElement }
  }

  if (googleMapsPromise) {
    return googleMapsPromise
  }

  googleMapsPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script')
    const params = new URLSearchParams({
      key: apiKey,
      v: 'weekly',
      loading: 'async',
      callback: '__googleMapsBeaconInit'
    })

    script.src = `https://maps.googleapis.com/maps/api/js?${params.toString()}`
    script.async = true
    script.defer = true
    script.onerror = () => reject(new Error('The Google Maps JavaScript API could not load.'))

    window.__googleMapsBeaconInit = async () => {
      try {
        const { Map, InfoWindow, LatLngBounds } = await google.maps.importLibrary('maps')
        const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary('marker')
        resolve({ Map, InfoWindow, LatLngBounds, AdvancedMarkerElement, PinElement })
      } catch (error) {
        reject(error)
      } finally {
        delete window.__googleMapsBeaconInit
      }
    }

    document.head.appendChild(script)
  })

  return googleMapsPromise
}

export default class extends Controller {
  static targets = ['map', 'status', 'publishButton', 'stopButton', 'count', 'list', 'currentExpiresAt', 'currentExpiresIn']
  static values = {
    apiKey: String,
    mapId: String,
    beaconsUrl: String,
    publishUrl: String,
    destroyUrl: String,
    centerLat: Number,
    centerLng: Number,
    zoom: Number,
    i18n: String
  }

  async connect() {
    this.messages = JSON.parse(this.i18nValue || '{}')
    this.markers = new Map()
    this.currentBeacon = null
    this.pollTimer = null
    this.countdownTimer = null
    this.boundsAdjusted = false

    if (!this.apiKeyValue) {
      this.disableControls()
      this.setStatus(this.messages.api_key_missing)
      return
    }

    this.setStatus(this.messages.loading)

    try {
      this.googleMaps = await loadGoogleMaps(this.apiKeyValue)
      this.map = new this.googleMaps.Map(this.mapTarget, {
        center: { lat: this.centerLatValue, lng: this.centerLngValue },
        zoom: this.zoomValue,
        mapId: this.mapIdValue || 'DEMO_MAP_ID',
        streetViewControl: false,
        fullscreenControl: false,
        mapTypeControl: false
      })
      this.infoWindow = new this.googleMaps.InfoWindow()

      await this.refresh().catch((error) => {
        console.error(error)
        this.setStatus(this.messages.refresh_error)
      })
      this.startPolling()
      this.startCountdown()
    } catch (error) {
      console.error(error)
      this.disableControls()
      this.setStatus(this.messages.load_error)
    }
  }

  disconnect() {
    clearInterval(this.pollTimer)
    clearInterval(this.countdownTimer)
  }

  async publish() {
    if (!navigator.geolocation) {
      this.setStatus(this.messages.geolocation_missing)
      return
    }

    this.publishButtonTarget.disabled = true
    this.setStatus(this.messages.locating)

    navigator.geolocation.getCurrentPosition(
      async (position) => {
        this.setStatus(this.messages.publishing)

        try {
          await this.request(this.publishUrlValue, {
            method: 'POST',
            body: JSON.stringify({
              beacon: {
                latitude: position.coords.latitude,
                longitude: position.coords.longitude,
                accuracy_meters: Math.round(position.coords.accuracy)
              }
            })
          })

          this.boundsAdjusted = false
          await this.refresh()
          this.setStatus(this.messages.sharing)
        } catch (_error) {
          this.setStatus(this.messages.publish_error)
        } finally {
          this.publishButtonTarget.disabled = false
        }
      },
      (error) => {
        this.publishButtonTarget.disabled = false
        if (error.code === 1) {
          this.setStatus(this.messages.geolocation_denied)
        } else {
          this.setStatus(this.messages.publish_error)
        }
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 60000
      }
    )
  }

  async stopSharing() {
    this.stopButtonTarget.disabled = true
    this.setStatus(this.messages.stopping)

    try {
      await this.request(this.destroyUrlValue, { method: 'DELETE' })
      this.boundsAdjusted = false
      await this.refresh()
      this.setStatus(this.messages.stopped)
    } catch (_error) {
      this.setStatus(this.messages.stop_error)
    } finally {
      this.stopButtonTarget.disabled = !this.currentBeacon
    }
  }

  async refresh() {
    const response = await fetch(this.beaconsUrlValue, {
      headers: { Accept: 'application/json' },
      credentials: 'same-origin'
    })

    if (!response.ok) {
      throw new Error('Beacon refresh failed')
    }

    const payload = await response.json()
    this.renderBeacons(payload.beacons || [])
    this.renderCurrentBeacon(payload.current_beacon || null)
  }

  renderBeacons(beacons) {
    const ids = new Set(beacons.map((beacon) => beacon.id))

    this.markers.forEach((marker, id) => {
      if (!ids.has(id)) {
        marker.map = null
        this.markers.delete(id)
      }
    })

    beacons.forEach((beacon) => {
      const position = { lat: beacon.latitude, lng: beacon.longitude }
      const label = beacon.name.toString().trim().slice(0, 1).toUpperCase()
      let marker = this.markers.get(beacon.id)

      if (!marker) {
        const pin = new this.googleMaps.PinElement({
          background: beacon.current_user ? '#0B374D' : '#FF5719',
          borderColor: '#FFFFFF',
          glyphColor: '#FFFFFF',
          glyphText: label,
          scale: 1.05
        })

        marker = new this.googleMaps.AdvancedMarkerElement({
          map: this.map,
          position,
          title: beacon.name,
          content: pin,
          gmpClickable: true
        })
        marker.addEventListener('gmp-click', () => {
          this.infoWindow.setContent(this.infoWindowContent(beacon))
          this.infoWindow.open({ anchor: marker, map: this.map })
        })
        this.markers.set(beacon.id, marker)
      } else {
        marker.position = position
        marker.title = beacon.name
      }
    })

    if (!this.boundsAdjusted) {
      this.fitBounds(beacons)
      this.boundsAdjusted = true
    }

    this.renderList(beacons)
    this.countTarget.textContent = beacons.length
    requestAnimationFrame(() => {
      window.google?.maps?.event?.trigger(this.map, 'resize')
    })
  }

  renderCurrentBeacon(beacon) {
    this.currentBeacon = beacon
    this.stopButtonTarget.disabled = !beacon
    this.publishButtonTarget.disabled = false

    if (!beacon) {
      this.currentExpiresAtTarget.textContent = '-'
      this.currentExpiresInTarget.textContent = '-'
      if (this.statusTarget.textContent === this.messages.sharing || this.statusTarget.textContent === this.messages.publishing) {
        this.setStatus(this.messages.not_sharing)
      }
      return
    }

    this.currentExpiresAtTarget.textContent = this.formatDateTime(beacon.expires_at)
    this.updateCurrentBeaconCountdown()
  }

  renderList(beacons) {
    this.listTarget.innerHTML = ''

    if (beacons.length === 0) {
      const empty = document.createElement('p')
      empty.className = 'rounded-lg bg-[var(--semantic-neutral-background-sub)] p-3 text-sm text-[var(--semantic-neutral-text-sub)]'
      empty.textContent = this.messages.list_empty
      this.listTarget.appendChild(empty)
      return
    }

    beacons.forEach((beacon) => {
      const row = document.createElement('button')
      row.type = 'button'
      row.className = 'flex w-full items-center gap-3 rounded-lg bg-[var(--semantic-neutral-background-sub)] p-3 text-left'
      row.addEventListener('click', () => {
        this.map.panTo({ lat: beacon.latitude, lng: beacon.longitude })
        this.map.setZoom(Math.max(this.map.getZoom(), 14))
      })

      const avatar = document.createElement('img')
      avatar.src = beacon.avatar_url
      avatar.alt = beacon.name
      avatar.className = 'h-10 w-10 rounded-full border border-[var(--semantic-neutral-line-sub)] bg-white'
      row.appendChild(avatar)

      const text = document.createElement('div')
      text.className = 'min-w-0 flex-1'

      const title = document.createElement('div')
      title.className = 'flex items-center gap-2'

      const name = document.createElement('p')
      name.className = 'truncate text-sm font-bold text-[var(--semantic-neutral-text)]'
      name.textContent = beacon.name
      title.appendChild(name)

      if (beacon.current_user) {
        const badge = document.createElement('span')
        badge.className = 'rounded-full bg-white px-2 py-0.5 text-[10px] font-bold text-[var(--semantic-neutral-text-sub)]'
        badge.textContent = this.messages.current_user
        title.appendChild(badge)
      }

      const expires = document.createElement('p')
      expires.className = 'text-xs text-[var(--semantic-neutral-text-sub)]'
      expires.textContent = `${this.messages.expires_at}: ${this.formatDateTime(beacon.expires_at)}`

      text.appendChild(title)
      text.appendChild(expires)
      row.appendChild(text)

      this.listTarget.appendChild(row)
    })
  }

  fitBounds(beacons) {
    if (beacons.length === 0) {
      this.map.setCenter({ lat: this.centerLatValue, lng: this.centerLngValue })
      this.map.setZoom(this.zoomValue)
      return
    }

    if (beacons.length === 1) {
      this.map.setCenter({ lat: beacons[0].latitude, lng: beacons[0].longitude })
      this.map.setZoom(Math.max(this.zoomValue, 14))
      return
    }

    const bounds = new this.googleMaps.LatLngBounds()
    beacons.forEach((beacon) => bounds.extend({ lat: beacon.latitude, lng: beacon.longitude }))
    this.map.fitBounds(bounds, 64)
  }

  infoWindowContent(beacon) {
    const container = document.createElement('div')
    container.className = 'min-w-[180px] space-y-1'

    const title = document.createElement('p')
    title.className = 'font-bold'
    title.textContent = beacon.name
    container.appendChild(title)

    const expires = document.createElement('p')
    expires.textContent = `${this.messages.expires_at}: ${this.formatDateTime(beacon.expires_at)}`
    container.appendChild(expires)

    if (beacon.accuracy_meters) {
      const accuracy = document.createElement('p')
      accuracy.textContent = `${this.messages.accuracy}: ${beacon.accuracy_meters}m`
      container.appendChild(accuracy)
    }

    return container
  }

  startPolling() {
    this.pollTimer = setInterval(() => {
      this.refresh().catch(() => {
        this.setStatus(this.messages.refresh_error)
      })
    }, 30000)
  }

  startCountdown() {
    this.countdownTimer = setInterval(() => this.updateCurrentBeaconCountdown(), 1000)
  }

  updateCurrentBeaconCountdown() {
    if (!this.currentBeacon) {
      this.currentExpiresInTarget.textContent = '-'
      return
    }

    const diff = Date.parse(this.currentBeacon.expires_at) - Date.now()

    if (diff <= 0) {
      this.currentBeacon = null
      this.currentExpiresAtTarget.textContent = '-'
      this.currentExpiresInTarget.textContent = '-'
      this.boundsAdjusted = false
      this.refresh().catch(() => {
        this.setStatus(this.messages.refresh_error)
      })
      return
    }

    this.currentExpiresInTarget.textContent = this.formatDistance(diff)
  }

  formatDateTime(value) {
    const date = new Date(value)
    return new Intl.DateTimeFormat(undefined, {
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date)
  }

  formatDistance(milliseconds) {
    const seconds = Math.max(0, Math.floor(milliseconds / 1000))
    const minutes = Math.floor(seconds / 60)
    const remainder = seconds % 60
    return `${minutes}:${remainder.toString().padStart(2, '0')}`
  }

  setStatus(message) {
    this.statusTarget.textContent = message
  }

  disableControls() {
    this.publishButtonTarget.disabled = true
    this.stopButtonTarget.disabled = true
  }

  request(url, options = {}) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    return fetch(url, {
      credentials: 'same-origin',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      ...options
    }).then((response) => {
      if (!response.ok) {
        throw new Error('Request failed')
      }

      if (response.status === 204) {
        return null
      }

      return response.json()
    })
  }
}
