import { Controller } from "@hotwired/stimulus"
import * as WebauthUtils from "webauth_utils";

export default class extends Controller {

  create(event) {
    console.log("Enter Stimiulus Controller NewRegistrationController#create");

    var [data, status, xhr] = event.detail;

    console.log(data);

    var credentialOptions = data;

    // Registration
    if (credentialOptions["user"]) {
      console.log("Registration credentialOptions user: " + credentialOptions["user"]);

      var credential_nickname = event.target.querySelector("input[name='registration[nickname]']").value;
      console.log("Registration credential_nickname: " + credential_nickname);

      var callback_url = `/registrations/callback?credential_nickname=${credential_nickname}`
      console.log("Registration callback_url: " + callback_url);

      console.log("Calling WebauthUtils.create");
      WebauthUtils.create(encodeURI(callback_url), credentialOptions);
    } else {
      console.log("Registration credentialOptions user is null");
    }
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
