FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password Faker::Internet.password
    association :role, factory: :user_role
  end
end
