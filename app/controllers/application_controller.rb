# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  before_action :enforce_current_user

  private

  def sign_in(user)
    session[:user_id] = user.id
    Current.user = user
  end

  def sign_out
    session[:user_id] = nil
    Current.user = nil
  end

  def current_user
    return nil unless Current.user

    @current_user ||= Current.user
  end

  def enforce_current_user
    return if current_user.present?

    redirect_to new_registrations_url
  end
end
