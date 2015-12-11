FactoryGirl.define do
  factory :user_role, class: Role do
    name '_user'
    short_name '_user'
  end

  factory :admin_role, class: Role do
    name '_admin'
    short_name '_admin'
  end

  factory :hr_role, class: Role do
    name '_hr'
    short_name '_hr'
  end

  factory :office_employee, class: Role do
    name '_office_employee'
    short_name '_office_employee'
  end

  factory :random_role, class: Role do
    name Faker::Name.name
    short_name Faker::Name.name
  end
end
