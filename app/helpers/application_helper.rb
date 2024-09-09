# frozen_string_literal: true

require "digest/md5"

module ApplicationHelper
  def gravatar_url(size: 80)
    default_url = "https://www.gravatar.com/avatar/00000000000000000000000000000000"
    return default_url unless current_user

    # Normalize the email address
    normalized_email = current_user.username.strip.downcase

    # Generate the MD5 hash of the normalized email
    hash = Digest::MD5.hexdigest(normalized_email)

    # Construct and return the Gravatar URL with optional size parameter
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  def user_email
    return "john.doe@example.com" unless current_user

    current_user.email
  end

  def user_name
    return "John Doe" unless current_user

    current_user.name
  end
end
