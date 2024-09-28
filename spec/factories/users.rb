FactoryBot.define do
  factory :user do
    transient do
      generate_name { FFaker::Name.name }
    end
    name { generate_name }
  end
end
