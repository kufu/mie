import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="schedule-table"
export default class extends Controller {
  connect() {
    var id = window.location.hash
    var tables = document.getElementsByClassName("schedule-table");

    if (id == "") {
      tables[0].classList.remove("hidden")
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

    window.location.hash = '#' + event.currentTarget.value;
  }
}
