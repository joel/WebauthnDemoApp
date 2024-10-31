# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test # rack_test by default, for performance
  end

  config.before(:each, :js, type: :system) do
    driven_by :headless_chrome # selenium when we need javascript
  end

  config.before(:each, :authentication, type: :system) do
    driven_by :selenium, using: (ENV["TEST_BROWSER"] || :chrome).to_sym, screen_size: [1400, 1400]

    Capybara.app_host = Rails.configuration.webauthn_origin # "http://localhost:3030"
    Capybara.server_host = "localhost"
    Capybara.server_port = 3030
    Capybara.default_max_wait_time = 20
  end
end
