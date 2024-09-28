module RequestAuthenticatedHelper
  def sign_in_as(*)
    allow(Current).to receive(:user).and_return(:authenticated_user)
  end
end

module ControllerAuthenticatedHelper
  def sign_in_as(*)
    allow(Current).to receive(:user).and_return(:authenticated_user)
  end
end

module SystemAuthenticatedHelper
  def sign_in_as(*)
    allow(Current).to receive(:user).and_return(:authenticated_user)
  end
end

RSpec.configure do |config|
  config.include RequestAuthenticatedHelper, type: :request
  config.include ControllerAuthenticatedHelper, type: :controller
  config.include SystemAuthenticatedHelper, type: :system
end
