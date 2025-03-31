import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="sessions"
export default class extends Controller {
  static targets = ['icon', 'sessions', 'session'];
  static values = { isOpen: { type: Boolean, default: true } };

  connect () {
    // アイコンが存在する場合のみ実行（セッションが2件以上ある場合）
    if (this.hasIconTarget) {
      // isOpenValueがfalseの場合、アイコンは右向き（閉じている）
      // isOpenValueがtrueの場合、アイコンは下向き（開いている）
      this.iconTarget.classList.toggle('fa-angle-right', !this.isOpenValue);
      this.iconTarget.classList.toggle('fa-angle-down', this.isOpenValue);
    }
  }

  toggle () {
    if (this.sessionTargets.length < 2) {
      return;
    }

    const selected = this.sessionTargets.findIndex((el) => el.classList.contains('selected')) >= 0;

    this.sessionTargets.forEach((el) => {
      if (!el.classList.contains('selected')) {
        el.classList.toggle('hidden', this.isOpenValue);
      }
      if (el.classList.contains('blank-box') && !selected) {
        el.classList.toggle('hidden', false);
      }
    });

    // 値を先に変更
    this.isOpenValue = !this.isOpenValue;

    // 変更後の値に基づいてアイコン状態を更新
    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle('fa-angle-right', !this.isOpenValue);
      this.iconTarget.classList.toggle('fa-angle-down', this.isOpenValue);
    }
  }
}
