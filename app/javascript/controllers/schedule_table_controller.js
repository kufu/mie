import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="schedule-table"
export default class extends Controller {
  connect () {
    const id = window.location.hash;
    const tables = document.getElementsByClassName('schedule-table');
    const buttons = document.getElementsByClassName('tab-button');

    if (tables.length <= 0) {
      return;
    }

    if (id === '') {
      tables[0].classList.remove('hidden');
      buttons[0].classList.add('tab-btn-active');
      return;
    }

    const target = document.getElementById('schedule-' + id.slice(1));

    [...tables].forEach(element => {
      if (element.id === target.id) {
        element.classList.remove('hidden');
      } else {
        element.classList.add('hidden');
      }
    });

    [...buttons].forEach(element => {
      if (element.value === id.slice(1)) {
        element.classList.add('tab-btn-active');
      }
    });
  }

  switch (event) {
    const tables = document.getElementsByClassName('schedule-table');
    const target = document.getElementById('schedule-' + event.currentTarget.value);

    [...tables].forEach(element => {
      if (element.id === target.id) {
        element.classList.remove('hidden');
      } else {
        element.classList.add('hidden');
      }
    });

    const buttons = document.getElementsByClassName('tab-button');
    [...buttons].forEach(element => {
      element.classList.remove('tab-btn-active');
    });

    event.currentTarget.classList.add('tab-btn-active');

    window.location.hash = '#' + event.currentTarget.value;
  }
}
