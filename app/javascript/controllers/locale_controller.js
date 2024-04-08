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
      Turbo.visit(this.nonSearchParamURL(window.location) + '?' + new URLSearchParams({ locale: dayjs.tz.guess() }));
    }
  }

  change (e) {
    Turbo.visit(this.nonSearchParamURL(window.location) + '?' + new URLSearchParams({ locale: e.target.value }));
  }

  nonSearchParamURL (location) {
    return location.toString().split('?')[0];
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
