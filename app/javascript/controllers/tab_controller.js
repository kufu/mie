import { Controller } from '@hotwired/stimulus';

// Connects to data-controller='tab'
export default class extends Controller {
  static targets = ['button', 'tab'];
  static values = { current: { type: Number, default: 0 } };

  connect () {
    const id = window.location.hash;
    this.buttonTargets.forEach((el, i) => {
      if ('#' + this.buttonId(el) === id) this.currentValue = i;
    });
    this.switch({ target: this.buttonTargets[this.currentValue] });
  }

  switch (event) {
    this.buttonTargets.forEach((element, i) => {
      if (element === event.target) {
        this.currentValue = i;
        element.classList.add('font-bold', 'border-[#5E626E]');
        element.classList.remove('font-medium', 'border-transparent');
      } else {
        element.classList.remove('font-bold', 'border-[#5E626E]');
        element.classList.add('font-medium', 'border-transparent');
      }
    });

    this.tabTargets.forEach((element, i) => {
      this.currentValue === i ? element.classList.remove('hidden') : element.classList.add('hidden');
    });

    if (this.currentValue > 0) {
      window.location.hash = this.buttonId(this.buttonTargets[this.currentValue]);
    } else {
      window.location.hash = '';
    }
  }

  buttonId (element) {
    return element.id.replace('-tab-button', '');
  }
}
