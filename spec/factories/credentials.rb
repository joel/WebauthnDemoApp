FactoryBot.define do
  factory :credential do
    external_id { "EXTERNAL_ID - #{SecureRandom.base64(13)}" }
    public_key { "PUBLIC_KEY" }
    nickname { "NICKNAME" }
    sign_count { 1 }
    user
  end
end
