FactoryGirl.define do
  factory :admin_category, class: FormCategory do
    name 'admin'
  end

  factory :visits_category, class: FormCategory do
    name 'visits'
  end

  factory :patient_category, class: FormCategory do
    name 'Patient'
  end

  factory :hr_category, class: FormCategory do
    name 'HR'
  end
end
