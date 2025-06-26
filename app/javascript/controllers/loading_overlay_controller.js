import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="edit"
export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    this.show  = this.show.bind(this)
    this.hide  = this.hide.bind(this)
    this.element.addEventListener("turbo:submit-start", this.show)
    this.element.addEventListener("turbo:submit-end",   this.hide)
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.show)
    this.element.removeEventListener("turbo:submit-end",   this.hide)
  }

  show() {
    this.overlayTarget.classList.remove("hidden")
  }

  hide() {
    this.overlayTarget.classList.add("hidden")
  }
}
