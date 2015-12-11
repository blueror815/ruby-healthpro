FactoryGirl.define do
  factory :simple_job_type, class: JobType do
    title 'some_job_type'
    job_class 'some_job_type'
    payment_method_ids []
  end

  factory :job_type, class: JobType do
    title 'super'
    job_class 'super'
    payment_method_ids []
  end
end
