FactoryBot.define do
  factory :post do
    title { "Amazing #{FFaker::Product.product_name} - Model: #{FFaker::Product.model}" }
    body { "Description: #{FFaker::Lorem.paragraphs}" }
    user
  end
end
