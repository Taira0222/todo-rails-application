import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dropdown"
export default class extends Controller {
  _clickOutside = (event) => {
    // open が true (= メニューが開いている) && クリック先が details の内側ではない
    if (this.element.open && !this.element.contains(event.target)) {
      this.element.open = false; // メニューを閉じる
    }
  };

  connect() {
    // ドキュメント全体で「クリックされたら _clickOutside を呼ぶ」
    document.addEventListener('click', this._clickOutside);
  }

  disconnect() {
    // Controller が外れたときにイベントリスナーを解除
    document.removeEventListener('click', this._clickOutside);
  }
}
