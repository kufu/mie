import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  connect() {
    document.documentElement.classList.add("overflow-hidden");

    var modal = document.getElementById("dialog-modal");
    modal.addEventListener("close", (e) => {
      document.documentElement.classList.remove("overflow-hidden");
    })

    modal.showModal();
  }

  close() {
    var modal = document.getElementById("dialog-modal");

    modal.close();
  }
}
