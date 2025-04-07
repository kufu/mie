import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  close() {
    this.element.classList.add("hidden")
  }
}
