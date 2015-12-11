FactoryGirl.define do
  factory :job_type_form do
    association :job_type, factory: :job_type
    association :custom_form, factory: :custom_form
  end
end
