# frozen_string_literal: true

require "ostruct"

class RegistrationsController < ApplicationController
  skip_before_action :enforce_current_user

  rescue_from WebAuthn::Error, with: :webauthn_error

  def new
    username = FFaker::Name.first_name
    @registration = OpenStruct.new(username:, nickname: "#{username}'s Security Key")
  end

  def create
    params[:registration][:webauthn_id] = WebAuthn.generate_user_id

    create_options = relying_party.options_for_registration(
      user: {
        name: params[:registration][:username],
        id: params[:registration][:webauthn_id]
      },
      authenticator_selection: { user_verification: "required" }
    )

    user = User.new(name: params[:registration][:username])
    if user.valid?
      session[:current_registration] = {
        challenge: create_options.challenge,
        registration_info: params[:registration].to_unsafe_h
      }.deep_symbolize_keys

      respond_to do |format|
        format.json { render json: create_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    session[:current_registration].deep_symbolize_keys!

    webauthn_credential = relying_party.verify_registration(
      params,
      session[:current_registration][:challenge],
      user_verification: Rails.configuration.x.webauthn.user_verification
    )

    user = User.new(
      name: session[:current_registration][:registration_info][:username],
      webauthn_id: session[:current_registration][:registration_info][:webauthn_id]
    )

    credential = user.credentials.build(
      external_id: Base64.strict_encode64(webauthn_credential.raw_id),
      nickname: params[:credential_nickname],
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )

    if user.valid? && credential.valid?
      user.save!
      sign_in(user)

      render json: { status: "ok" }, status: :ok
    else
      render json: "Couldn't register your Security Key", status: :unprocessable_entity
    end
  ensure
    Rails.logger.debug("Deleting current registration 1.")

    session.delete(:current_registration)
  end

  private

  def webauthn_error(error)
    render json: { error: "Verification failed: #{error.message}" }, status: :unprocessable_entity
    Rails.logger.debug("Deleting current registration 2.")
    session.delete(:current_registration)
  end

  def relying_party
    @relying_party ||= RelyingPartyService.new
  end
end
