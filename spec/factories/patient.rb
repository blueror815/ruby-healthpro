FactoryGirl.define do
  factory :patient do
    email Faker::Internet.email
    display_name Faker::Name.name
  end
end
