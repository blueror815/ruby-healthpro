FactoryGirl.define do
  factory :payroll do
    start_date Time.zone.now - 1.day
  end
end
