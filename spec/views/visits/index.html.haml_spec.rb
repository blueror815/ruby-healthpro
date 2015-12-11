require 'rails_helper'

RSpec.describe 'visits/index', type: :view do
  before(:each) do
    @role = FactoryGirl.create(:admin_role)
    @job_type = FactoryGirl.create(:simple_job_type)
    @user = FactoryGirl.create(:user, role_id: @role.id)
    sign_in(@user)

    assign(:visits, [
      Visit.create!(
        progress_state: 'visited',
        billing_state: 'Billing State',
        billing_code: 'Billing Code',
        agency_id: 1,
        assigner_id: 2,
        assignee_id: 3,
        patient_id: 4,
        visit_type_id: 5
      ),
      Visit.create!(
        progress_state: 'visited',
        billing_state: 'Billing State',
        billing_code: 'Billing Code',
        agency_id: 1,
        assigner_id: 2,
        assignee_id: 3,
        patient_id: 4,
        visit_type_id: 5
      )
    ])
  end

  it 'renders a list of visits' do
   
  end
end
