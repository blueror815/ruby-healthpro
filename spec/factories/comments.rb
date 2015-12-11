FactoryGirl.define do
  factory :comment, class: CustomForms::Comment do
    association :user, factory: :user
    form_datum_id 1
    content Faker::Lorem.sentence
  end
end
