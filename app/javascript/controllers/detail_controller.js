import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="detail"
export default class extends Controller {
  static targets = ['content', 'icon', 'button'];

  toggle() {
    const isOpen = this.buttonTarget.getAttribute('aria-expanded') === 'true';

    if (isOpen) {
      // 閉じる
      this.contentTarget.style.maxHeight = '0';
      this.iconTarget.classList.remove('rotate-90');
      this.buttonTarget.setAttribute('aria-expanded', 'false');
    } else {
      // 開く
      this.contentTarget.style.maxHeight = `${this.contentTarget.scrollHeight}px`;
      this.iconTarget.classList.add('rotate-90');
      this.buttonTarget.setAttribute('aria-expanded', 'true');
    }
  }
}
