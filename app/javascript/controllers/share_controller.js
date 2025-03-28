import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share"
export default class extends Controller {
  static values = { title: String, text: String, url: String }

  click() {
    if (navigator.share) {
      navigator.share({
        title: this.titleValue,
        text: this.textValue,
        url: this.urlValue
      }).catch((_error) => {
        // do nothing
      })
    } else {
      window.open(this.urlValue, "_blank")
    }
  }
}
