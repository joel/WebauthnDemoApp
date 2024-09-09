// app/javascript/controllers/panel_toggle_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panel"];

  toggle() {
    this.panelTarget.classList.toggle("hidden");
    console.log("toggling");
  }
}
