import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="schedule-table"
export default class extends Controller {
  static targets = ['row'];

  connect () {
    const id = window.location.hash;
    const tables = document.getElementsByClassName('schedule-table');
    const buttons = document.getElementsByClassName('tab-button');

    this.highlightCurrentEvent();
    this.highlightTimer = setInterval(() => this.highlightCurrentEvent(), 60 * 1000);

    if (tables.length <= 0) {
      return;
    }


    if (id === '') {
      const current = new Date();
      const today = `${current.getFullYear()}-${("0"+(current.getMonth() + 1)).slice(-2)}-${current.getDate()}`;
      var index = [...buttons].findIndex((button) => button.value.toString() === today );

      if (index === -1) {
        index = 0
      }

      tables[index].classList.remove('hidden');
      buttons[index].classList.add('tab-btn-active');

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

  disconnect () {
    if (this.highlightTimer) {
      clearInterval(this.highlightTimer);
      this.highlightTimer = null;
    }
  }

  rowTargetConnected () {
    this.highlightCurrentEvent();
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

  highlightCurrentEvent () {
    const now = new Date();

    this.rowTargets.forEach((row) => {
      row.classList.remove('event-current', 'event-next');
    });

    const rows = this.rowTargets
      .map((el) => ({
        el,
        startAt: new Date(el.dataset.startAt),
        endAt: new Date(el.dataset.endAt)
      }))
      .sort((a, b) => a.startAt - b.startAt);

    const current = rows.find(({ startAt, endAt }) => startAt <= now && now < endAt);
    if (current) {
      current.el.classList.add('event-current');
      return;
    }

    const next = rows.find(({ startAt }) => startAt > now);
    if (next) {
      next.el.classList.add('event-next');
    }
  }
}
