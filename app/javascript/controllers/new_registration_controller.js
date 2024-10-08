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
    let response = event.detail[0];
    console.log(response);
  }
}