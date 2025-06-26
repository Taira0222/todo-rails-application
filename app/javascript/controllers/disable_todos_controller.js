import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="disable_todos"
export default class extends Controller {
  connect() {
    // ToDo 行のオーバーレイ
    this._addOverlays('li[id^="todo_"]')
    // 「todoを追加」ボタンのオーバーレイ
    this._addOverlays('div[id^="add_todo_button_"]')
  }

  disconnect() {
    this._removeOverlays('li[id^="todo_"]')
    this._removeOverlays('div[id^="add_todo_button_"]')
  }

  _addOverlays(selector) {
    document.querySelectorAll(selector).forEach(el => {
      el.classList.add('relative')
      const overlay = document.createElement('div')
      overlay.dataset.overlay = true
      overlay.className = 'absolute inset-0 z-10'
      el.appendChild(overlay)
    })
  }

  _removeOverlays(selector) {
    document.querySelectorAll(selector).forEach(el => {
      el.querySelectorAll('[data-overlay]').forEach(o => o.remove())
      el.classList.remove('relative')
    })
  }
}
