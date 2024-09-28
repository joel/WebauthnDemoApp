Rails.application.config.hosts << "#{ENV["NGROK_DOMAIN"]}.ngrok-free.app" if ENV["NGROK_DOMAIN"]
