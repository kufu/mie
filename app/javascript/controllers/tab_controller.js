import { Controller } from '@hotwired/stimulus';

// Connects to data-controller='tab'
export default class extends Controller {
  static targets = ['button', 'tab'];
  static values = { current: { type: Number, default: 0 } };

  connect () {
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
  }
}
