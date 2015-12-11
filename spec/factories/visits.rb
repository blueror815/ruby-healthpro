FactoryGirl.define do
  factory :visit do
    progress_state "visited"
    billing_state "MyString"
    billing_code "MyString"
    date "2015-07-29"
    assigned_time "2015-07-29 12:18:16"
    occurred_time "2015-07-29 12:18:16"
    agency_id 1
    patient_id 1
    association :assignee, factory: :user # , role: FactoryGirl.create(:user_role, name: 'random_role', short_name: "random_short"))
    association :patient, factory: :patient
    association :visit_type, factory: :visit_type
    after(:create) do |visit|
      visit.assigner = FactoryGirl.create(:user, email: 'random@prohealth.com', role: FactoryGirl.create(:user_role, name: 'random_role1', short_name: 'random_short1'))
      visit.reimbursements << FactoryGirl.create(:reimbursement)
    end
  end

  factory :visit_without_patient do 
    progress_state "visited"
    billing_state "MyString"
    billing_code "MyString"
    date "2015-07-29"
    assigned_time "2015-07-29 12:18:16"
    occurred_time "2015-07-29 12:18:16"
    agency_id 1
    patient_id 1
    after(:create) do |visit|
      visit.visit_type = FactoryGirl.create(:visit_type)
      visit.assignee = FactoryGirl.create(:user, role: FactoryGirl.create(:user_role, name: 'random_role', short_name: 'random_short'))
      visit.assigner = FactoryGirl.create(:user, email: 'random@prohealth.com', role: FactoryGirl.create(:user_role, name: 'random_role1', short_name: 'random_short1'))
    end
  end

  factory :empty_visit do 
    progress_state "visited"
    billing_state "MyString"
    billing_code "MyString"
    date "2015-07-29"
    assigned_time "2015-07-29 12:18:16"
    occurred_time "2015-07-29 12:18:16"
    agency_id 1
  end


  factory :visit_without_reimbursements, class: Visit do
    progress_state "visited"
    billing_state "MyString"
    billing_code "MyString"
    date "2015-07-29"
    assigned_time "2015-07-29 12:18:16"
    occurred_time "2015-07-29 12:18:16"
    agency_id 1
    patient_id 1
    association :assignee, factory: :user#, role: FactoryGirl.create(:user_role, name: 'random_role', short_name: "random_short"))
    association :patient, factory: :patient
    association :visit_type, factory: :visit_type
    after(:create) do |visit|
      visit.assigner = FactoryGirl.create(:user, email: 'random@prohealth.com',  role: FactoryGirl.create(:user_role, name: 'random_role1', short_name: "random_short1"))
    end
  end
end
