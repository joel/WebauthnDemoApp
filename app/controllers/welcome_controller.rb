# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :enforce_current_user

  def home; end
end
