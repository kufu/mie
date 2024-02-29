import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="word-counter"
export default class extends Controller {
  static targets = [ "source", "counter", "submit" ];
  static values = { max: { type: Number, default: 0 } };

  connect() {
    this.calc()
  }

  calc() {
    var count = this.maxValue - this.sourceTarget.value.length;

    if (count < 0 ) {
      this.counterTarget.classList.add("text-red");
      this.submitTarget.disabled = true;
    } else {
      this.counterTarget.classList.remove("text-red");
      this.submitTarget.disabled = false;
    }

    this.counterTarget.innerHTML =  count;
  }
}
