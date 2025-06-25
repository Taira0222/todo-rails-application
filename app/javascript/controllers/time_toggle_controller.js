import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="time-toggle"
export default class extends Controller {
  static targets = ["checkbox","timepicker"]
  
  connect() {
    // ページ読み込み時にチェック状態に応じて一度トグル
    this._updateVisibility()
  }

  toggle() {
    // チェックが変わったときにも同じ処理
    this._updateVisibility()
  }

  _updateVisibility() {
    if (this.checkboxTarget.checked) {
      this.timepickerTarget.classList.remove("hidden")
    } else {
      this.timepickerTarget.classList.add("hidden")
    }
  }
}
