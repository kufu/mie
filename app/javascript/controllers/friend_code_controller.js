import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="friend-code"
export default class extends Controller {
  static targets = ['counter']
  static values = { expiresAt: Number }

  connect() {
    this.calc();
    this.timer = setInterval(() => {
      this.calc();
    }, 1000);
  }

  disconnect() {
    clearInterval(this.timer);
  }

  calc () {
    const expiresAt = new Date(this.expiresAtValue);
    const now = Date.now();

    if (now < expiresAt) {
      this.counterTarget.innerHTML = Math.trunc((expiresAt - now) / 1000);
    } else {
      this.counterTarget.innerHTML = 0;

      fetch('/profile/friends/new', { headers: { Accept: "text/vnd.turbo-stream.html" } })
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html));
    }
  }
}
