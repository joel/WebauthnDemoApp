# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :enforce_current_user

  private

  def enforce_current_user
    return if current_user.present?

    redirect_to new_session_url
  end
end
