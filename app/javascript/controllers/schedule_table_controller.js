import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="schedule-table"
export default class extends Controller {
  connect() {
    var id = window.location.hash
    var tables = document.getElementsByClassName("schedule-table");
    var buttons = document.getElementsByClassName("tab-button");

    if (id == "") {
      tables[0].classList.remove("hidden");
      buttons[0].classList.add("tab-btn-active");
      return
    }

    var target = document.getElementById('schedule-' + id.slice(1));

    [...tables].forEach(element => {
      if (element.id == target.id) {
        element.classList.remove("hidden")
      } else {
        element.classList.add("hidden")
      }
    });

    [...buttons].forEach(element => {
      if (element.value == id.slice(1)) {
        element.classList.add("tab-btn-active")
      }
    })
  }

  switch(event) {
    var tables = document.getElementsByClassName("schedule-table");
    var target = document.getElementById('schedule-' + event.currentTarget.value);

    [...tables].forEach(element => {
      if (element.id == target.id) {
        element.classList.remove("hidden")
      } else {
        element.classList.add("hidden")
      }
    });

    var buttons = document.getElementsByClassName("tab-button");
    [...buttons].forEach(element => {
      element.classList.remove("tab-btn-active")
    })

    event.currentTarget.classList.add("tab-btn-active");

    window.location.hash = '#' + event.currentTarget.value;
  }
}
