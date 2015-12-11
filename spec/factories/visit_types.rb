FactoryGirl.define do
  factory :visit_type do
    title 'MyString'
    price 50.to_i
    after(:create) do |visit_type|
      visit_type.job_types << FactoryGirl.create(:job_type)
      visit_type.departments << FactoryGirl.create(:department)
      visit_type.reimbursements << FactoryGirl.create(:reimbursement)
    end
  end

  factory :visit_type_without_job_type_or_department, class: VisitType do
    title 'MyString'
    price 50.to_i
  end
end
