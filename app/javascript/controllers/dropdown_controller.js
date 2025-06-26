import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dropdown"
export default class extends Controller {
  connect() {
    // 外側クリックで閉じる
    document.addEventListener("click", this._clickOutside)

    // メニュー内の a や button 押下でも閉じる
    this.element.addEventListener("click", this._clickInside)
  }

  disconnect() {
    document.removeEventListener("click", this._clickOutside)
    this.element.removeEventListener("click", this._clickInside)
  }

  _clickOutside = (event) => {
    if (this.element.open && !this.element.contains(event.target)) {
      this.element.open = false
    }
  }

  _clickInside = (event) => {
    // メニューアイテム（リンク or ボタン）をクリックしたら閉じる
    if (event.target.closest("a, button")) {
      this.element.open = false
    }
  }
}
