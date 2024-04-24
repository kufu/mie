import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hamburger"
export default class extends Controller {
  static targets = ["sidebar", "hamburger", "x"]

  toggle() {
    this.hamburgerTarget.classList.toggle('hidden')
    this.xTarget.classList.toggle('hidden')
    this.sidebarTarget.classList.toggle('translate-x-full')
  }
}
