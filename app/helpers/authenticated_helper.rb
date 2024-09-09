# frozen_string_literal: true

module AuthenticatedHelper
  def authenticated?
    session[:user_id].present?
  end
end
