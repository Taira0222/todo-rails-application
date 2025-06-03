import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="done-button-submit"
export default class extends Controller {
  submit() {
    this.element.requestSubmit();
  }
}
