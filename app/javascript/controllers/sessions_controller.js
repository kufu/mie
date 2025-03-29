import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="sessions"
export default class extends Controller {
  static targets = ['icon', 'sessions', 'session'];
  static values = { isOpen: { type: Boolean, default: true }, key: { type: String } };

  connect () {
    // アイコンが存在する場合のみ実行（セッションが2件以上ある場合）
    if (this.hasIconTarget) {
      // isOpenValueがfalseの場合、アイコンは右向き（閉じている）
      // isOpenValueがtrueの場合、アイコンは下向き（開いている）
      this.iconTarget.classList.toggle('fa-angle-right', !this.isOpenValue);
      this.iconTarget.classList.toggle('fa-angle-down', this.isOpenValue);
    }

    if (this.storageAvailable('localStorage')) {
      if (localStorage.getItem(this.keyValue) === 'true' && this.isOpenValue === true) {
        this.toggle();
      }
    }
  }

  toggle () {
    if (this.sessionTargets.length < 2) {
      return;
    }

    let override = true;

    this.sessionTargets.forEach((el) => {
      if (!el.classList.contains('selected')) {
        el.classList.toggle('hidden', this.isOpenValue);
      } else {
        override = false;
      }
    });

    // 値を先に変更
    this.isOpenValue = !this.isOpenValue;

    // 未選択の状態でsessionsを閉じたとき、それは意思を持って閉じているので記憶する
    if (this.storageAvailable('localStorage')) {
      if (override && !this.isOpenValue) {
        localStorage.setItem(this.keyValue, 'true');
      } else {
        localStorage.removeItem(this.keyValue);
      }
    }

    // 変更後の値に基づいてアイコン状態を更新
    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle('fa-angle-right', !this.isOpenValue);
      this.iconTarget.classList.toggle('fa-angle-down', this.isOpenValue);
    }
  }

  storageAvailable (type) {
    let storage;
    try {
      storage = window[type];
      const x = '__storage_test__';
      storage.setItem(x, x);
      storage.removeItem(x);
      return true;
    } catch (e) {
      return (
        e instanceof DOMException &&
        // everything except Firefox
        (e.code === 22 ||
          // Firefox
          e.code === 1014 ||
          // test name field too, because code might not be present
          // everything except Firefox
          e.name === 'QuotaExceededError' ||
          // Firefox
          e.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
        // acknowledge QuotaExceededError only if there's something already stored
        storage &&
        storage.length !== 0
      );
    }
  }
}
