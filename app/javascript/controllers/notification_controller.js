import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

// Connects to data-controller="notification"
export default class extends Controller {
  connect () {
    enter(this.element);
  }

  close () {
    leave(this.element);
  }
}
