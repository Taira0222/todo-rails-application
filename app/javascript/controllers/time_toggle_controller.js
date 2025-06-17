import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="time-toggle"
export default class extends Controller {
  static targets = ["checkbox","timepicker"]
  
  toggle(){
    this.timepickerTarget.classList.toggle("hidden", !this.checkboxTarget.checked)
  }
}
