require "webauthn/fake_client"

FactoryBot.define do
  factory :credential do
    transient do
      raw_challenge         { SecureRandom.random_bytes(32) }
      challenge             { WebAuthn.configuration.encoder.encode(raw_challenge) }
      public_key_credential { WebAuthn::FakeClient.new(Rails.configuration.webauthn_origin).create(challenge:, user_verified: true) }
      webauthn_credential   { WebAuthn::Credential.from_create(public_key_credential) }
    end

    external_id { Base64.strict_encode64(webauthn_credential.raw_id) }
    public_key  { webauthn_credential.public_key }
    nickname    { "#{user.name}'s USB Key" }
    sign_count  { webauthn_credential.sign_count }

    user
  end
end
