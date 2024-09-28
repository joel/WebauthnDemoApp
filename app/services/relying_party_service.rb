# frozen_string_literal: true

class RelyingPartyService
  def options_for_registration(**keyword_arguments)
    relying_party.options_for_registration(**keyword_arguments)
  end

  def verify_registration(raw_credential, challenge, user_verification: nil)
    relying_party.verify_registration(raw_credential, challenge, user_verification:)
  end

  private

  def relying_party
    @relying_party ||=
      WebAuthn::RelyingParty.new(
        origin: Rails.configuration.webauthn_origin,
        name: "WebAuthn Rails Demo App"
      )
  end
end
