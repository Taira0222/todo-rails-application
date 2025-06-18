import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="edit"
export default class extends Controller {
  static values = {
    url: String, // 編集用URLを格納する
  };
  connect() {
    // 要素に dblclick イベントをバインド
    this.element.addEventListener('click', this.navigate.bind(this));
  }

  navigate() {
    Turbo.visit(this.urlValue);
  }
}
