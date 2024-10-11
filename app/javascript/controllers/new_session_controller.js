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
    let [response, status, xhr] = event.detail;
    console.log(response); // Logs the error response from the server

    // Display the error messages
    const errorExplanation = document.getElementById('error_explanation');
    const errorMessageList = errorExplanation.querySelector('ul');

    // Clear any existing error messages
    errorMessageList.innerHTML = '';

    response.errors.forEach(error => {
      let li = document.createElement('li');
      li.textContent = error;
      errorMessageList.appendChild(li);
    });

    // Make the error explanation visible
    errorExplanation.classList.remove('hidden');
  }
}

