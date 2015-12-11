require 'rails_helper'

RSpec.describe 'visits/edit', type: :view do
  before(:each) do
    @visit = assign(:visit, Visit.create!(
                              progress_state: 'visited',
                              billing_state: 'MyString',
                              billing_code: 'MyString',
                              agency_id: 1,
                              assigner_id: 1,
                              assignee_id: 1,
                              patient_id: 1,
                              visit_type_id: 1
    ))
  end

  it 'renders the edit visit form' do
    render

  end
end
