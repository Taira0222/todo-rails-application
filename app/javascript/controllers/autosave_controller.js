import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="autosave"
export default class extends Controller {
  // window 上のクリックで呼ばれる
  clickOutside(event) {
    const t = event.target;

    // フォーム内クリック or flatpickrカレンダー内クリック はスルー
    if (this.element.contains(t) || t.closest('.flatpickr-calendar')) return;

    // それ以外は保存
    this.element.requestSubmit();
  }
}
