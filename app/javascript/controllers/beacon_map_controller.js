import { Controller } from '@hotwired/stimulus'

let googleMapsPromise

async function loadGoogleMaps(apiKey) {
  if (window.google?.maps?.importLibrary) {
    const { Map, InfoWindow, LatLngBounds } = await google.maps.importLibrary('maps')
    const { AdvancedMarkerElement } = await google.maps.importLibrary('marker')

    return { Map, InfoWindow, LatLngBounds, AdvancedMarkerElement }
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
        const { AdvancedMarkerElement } = await google.maps.importLibrary('marker')
        resolve({ Map, InfoWindow, LatLngBounds, AdvancedMarkerElement })
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
  static targets = ['map', 'publishButton', 'stopButton', 'count', 'list', 'currentExpiresAt', 'currentExpiresIn', 'friendFilter']
  static values = {
    apiKey: String,
    mapId: String,
    beaconsUrl: String,
    publishUrl: String,
    destroyUrl: String,
    friendProfileIds: Array,
    centerLat: Number,
    centerLng: Number,
    zoom: Number,
    i18n: String
  }

  async connect() {
    this.messages = JSON.parse(this.i18nValue || '{}')
    this.markers = new Map()
    this.currentBeacon = null
    this.allBeacons = []
    this.pollTimer = null
    this.countdownTimer = null
    this.boundsAdjusted = false

    if (!this.apiKeyValue) {
      this.disableControls()
      return
    }

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
      })
      this.startPolling()
      this.startCountdown()
    } catch (error) {
      console.error(error)
      this.disableControls()
    }
  }

  disconnect() {
    clearInterval(this.pollTimer)
    clearInterval(this.countdownTimer)
  }

  async publish() {
    if (!navigator.geolocation) {
      console.error(new Error(this.messages.geolocation_missing))
      return
    }

    this.publishButtonTarget.disabled = true

    navigator.geolocation.getCurrentPosition(
      async (position) => {
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
        } catch (error) {
          console.error(error)
        } finally {
          this.publishButtonTarget.disabled = false
        }
      },
      (error) => {
        this.publishButtonTarget.disabled = false
        console.error(error)
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

    try {
      await this.request(this.destroyUrlValue, { method: 'DELETE' })
      this.boundsAdjusted = false
      await this.refresh()
    } catch (error) {
      console.error(error)
    } finally {
      this.stopButtonTarget.disabled = !this.currentBeacon
    }
  }

  toggleFriendFilter() {
    this.boundsAdjusted = false
    this.applyFilter()
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
    this.allBeacons = payload.beacons || []
    this.applyFilter()
    this.renderCurrentBeacon(payload.current_beacon || null)
  }

  applyFilter() {
    this.renderBeacons(this.visibleBeacons())
  }

  visibleBeacons() {
    if (!this.friendFilterTarget.checked) {
      return this.allBeacons
    }

    return this.allBeacons.filter((beacon) => beacon.current_user || this.friendProfileIdsValue.includes(beacon.profile_id))
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
      let marker = this.markers.get(beacon.id)

      if (!marker) {
        marker = new this.googleMaps.AdvancedMarkerElement({
          map: this.map,
          position,
          title: beacon.name,
          content: this.avatarMarkerContent(beacon),
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
        marker.content = this.avatarMarkerContent(beacon)
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

  avatarMarkerContent(beacon) {
    const wrapper = document.createElement('div')
    wrapper.style.display = 'flex'
    wrapper.style.flexDirection = 'column'
    wrapper.style.alignItems = 'center'
    wrapper.style.transform = 'translateY(-8px)'

    const avatar = document.createElement('div')
    avatar.style.width = '44px'
    avatar.style.height = '44px'
    avatar.style.borderRadius = '9999px'
    avatar.style.overflow = 'hidden'
    avatar.style.background = '#FFFFFF'
    avatar.style.boxShadow = '0 6px 18px rgba(0, 0, 0, 0.18)'
    avatar.style.border = beacon.current_user ? '3px solid #0B374D' : '3px solid #FF5719'

    const image = document.createElement('img')
    image.src = beacon.avatar_url
    image.alt = beacon.name
    image.style.display = 'block'
    image.style.width = '100%'
    image.style.height = '100%'
    image.style.objectFit = 'cover'

    const tail = document.createElement('div')
    tail.style.width = '0'
    tail.style.height = '0'
    tail.style.marginTop = '-1px'
    tail.style.borderLeft = '8px solid transparent'
    tail.style.borderRight = '8px solid transparent'
    tail.style.borderTop = beacon.current_user ? '12px solid #0B374D' : '12px solid #FF5719'

    avatar.appendChild(image)
    wrapper.appendChild(avatar)
    wrapper.appendChild(tail)

    return wrapper
  }

  startPolling() {
    this.pollTimer = setInterval(() => {
      this.refresh().catch((error) => {
        console.error(error)
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
      this.refresh().catch((error) => {
        console.error(error)
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
