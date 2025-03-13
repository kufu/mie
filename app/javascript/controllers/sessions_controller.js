import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sessions"
export default class extends Controller {
  static targets = [ "icon", "sessions", "session" ];
  static values = { isOpen: { type: Boolean, default: true } };

  toggle () {
    if (this.sessionTargets.length < 2) {
      return;
    }

    this.sessionTargets.forEach((el) => {
      if (!el.classList.contains("selected")) {
        el.classList.toggle("hidden", this.isOpenValue);
      }
    });
    this.iconTarget.classList.toggle("fa-angle-right", this.isOpenValue);
    this.iconTarget.classList.toggle("fa-angle-down", !this.isOpenValue);
    this.isOpenValue = !this.isOpenValue;
  }
}
