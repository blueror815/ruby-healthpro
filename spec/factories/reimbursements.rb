FactoryGirl.define do
  factory :reimbursement do
    title Faker::Lorem.word
    value_type 1
    price 9
  end

  factory :reimbursement_multible, class: Reimbursement do
    title Faker::Lorem.word
    value_type 2
    price 5
  end

end
