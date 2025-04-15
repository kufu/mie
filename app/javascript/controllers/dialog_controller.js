import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ['dialog'];
  static values = { elementId: String, open: { type: Boolean, default: false } };

  connect () {
    if (this.hasDialogTarget) {
      this.dialog = this.dialogTarget;
    } else {
      // for compatibility, elementId are deprecated.
      this.dialog = document.getElementById(this.elementIdValue);
    }
    if (this.openValue) {
      this.open();
    }
  }

  open () {
    document.documentElement.classList.add('overflow-hidden');
    this.original = this.dialogTarget.cloneNode(true);

    this.dialog.addEventListener('close', (e) => {
      document.documentElement.classList.remove('overflow-hidden');
    });

    this.dialog.showModal();
  }

  cancel () {
    this.dialogTarget.innerHTML = this.original.innerHTML;
    this.original = undefined;
    this.dialog.close();
  }

  close () {
    this.dialog.close();
  }

  disconnect () {
    this.close();
  }
}
