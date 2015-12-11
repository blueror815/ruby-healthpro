FactoryGirl.define do
  factory :job_types_visit_type do
    association :job_type, factory: :job_type
    association :visit_type, factory: :visit_type
  end
end
