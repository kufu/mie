import { Controller } from '@hotwired/stimulus';
import dayjs from 'dayjs';
import { Turbo } from '@hotwired/turbo-rails';

const utc = require('dayjs/plugin/utc');
const timezone = require('dayjs/plugin/timezone'); // dependent on utc plugin

dayjs.extend(utc);
dayjs.extend(timezone);

// Connects to data-controller="locale"
export default class extends Controller {
  static values = { current: { type: String, default: '' } };

  connect () {
    if (this.currentValue === '' && !this.isTestEnvironment) {
      const location = new URL(window.location.href);
      location.searchParams.set('locale', dayjs.tz.guess());
      Turbo.visit(location.href);
    }
  }

  change (e) {
    const location = new URL(window.location.href);
    location.searchParams.set('locale', e.target.value);
    Turbo.visit(location.href);
  }

  get isTestEnvironment() {
    const railsEnv = document.head.querySelector("meta[name=rails_env]")
    if ( railsEnv === null ) {
      return false;
    } else {
      return railsEnv.content === "test"
    }

  }
}
