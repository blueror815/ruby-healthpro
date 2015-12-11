FactoryGirl.define do
  factory :timesheet do
    association :payroll, factory: :payroll
    association :user, factory: :user

  end
end
