module RequestAuthenticatedHelper
  def sign_in_as(authenticated_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(authenticated_user)
  end
end

module ControllerAuthenticatedHelper
  def sign_in_as(authenticated_user)
    allow(controller).to receive(:current_user).and_return(authenticated_user)
  end
end

module SystemAuthenticatedHelper
  def sign_in_as(authenticated_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(authenticated_user)
  end

  def stub_create(fake_credential)
    # Encode binary fields to use in script
    encode(fake_credential, "rawId")
    encode(fake_credential["response"], "attestationObject")

    # Parse to avoid escaping already escaped characters
    fake_credential["response"]["clientDataJSON"] = JSON.parse(fake_credential["response"]["clientDataJSON"])

    page.execute_script(<<-SCRIPT)
      function encode(input) {
        return Uint8Array.from(input, c => c.charCodeAt(0));
      }

      let fakeCredential = JSON.parse('#{fake_credential.to_json}');

      fakeCredential.rawId = encode(atob(fakeCredential.rawId));
      fakeCredential.response.attestationObject = encode(atob(fakeCredential.response.attestationObject));
      fakeCredential.response.clientDataJSON = encode(JSON.stringify(fakeCredential.response.clientDataJSON));
      fakeCredential.getClientExtensionResults = function() { return {} };

      window.sinon.stub(navigator.credentials, 'create').resolves(fakeCredential);
    SCRIPT
  end

  def stub_get(fake_credential)
    # Encode binary fields to use in script
    encode(fake_credential, "rawId")
    encode(fake_credential["response"], "authenticatorData")
    encode(fake_credential["response"], "signature")

    # Parse to avoid escaping already escaped characters
    fake_credential["response"]["clientDataJSON"] = JSON.parse(fake_credential["response"]["clientDataJSON"])

    page.execute_script(<<-SCRIPT)
      function encode(input) {
        return Uint8Array.from(input, c => c.charCodeAt(0));
      }

      let fakeCredential = JSON.parse('#{fake_credential.to_json}');

      fakeCredential.rawId = encode(atob(fakeCredential.rawId));
      fakeCredential.response.authenticatorData = encode(atob(fakeCredential.response.authenticatorData));
      fakeCredential.response.clientDataJSON = encode(JSON.stringify(fakeCredential.response.clientDataJSON));
      fakeCredential.response.signature = encode(atob(fakeCredential.response.signature));
      fakeCredential.getClientExtensionResults = function() { return {} };

      window.sinon.stub(navigator.credentials, 'get').resolves(fakeCredential);
    SCRIPT
  end

  def encode(hash, key)
    hash[key] = Base64.strict_encode64(hash[key])
  end
end

RSpec.configure do |config|
  config.include RequestAuthenticatedHelper, type: :request
  config.include ControllerAuthenticatedHelper, type: :controller
  config.include SystemAuthenticatedHelper, type: :system
end
