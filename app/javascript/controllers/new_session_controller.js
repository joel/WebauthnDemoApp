import { Controller } from "@hotwired/stimulus"
import * as WebauthUtils from "webauth_utils";

// Connects to data-controller="new-session"
export default class extends Controller {
  connect() {
  }

  static targets = ["usernameField"]

  create(event) {
    var [data, status, xhr] = event.detail;
    console.log(data);
    var credentialOptions = data;
    WebauthUtils.get(credentialOptions);
  }

  error(event) {
    var [data, status, xhr] = event.detail;
    let response = data;
    console.log(response.errors[0]);
  }
}

