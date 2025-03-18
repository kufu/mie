import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ['dialog'];
  static values = { elementId: String, open: { type: Boolean, default: false } };

  connect () {
    this.dialog = this.dialogTarget || document.getElementById(this.elementIdValue);
    if (this.openValue) {
      this.open();
    }
  }

  open () {
    document.documentElement.classList.add('overflow-hidden');

    this.dialog.addEventListener('close', (e) => {
      document.documentElement.classList.remove('overflow-hidden');
    });

    this.dialog.showModal();
  }

  close () {
    this.dialog.close();
  }

  disconnect () {
    this.close();
  }
}
