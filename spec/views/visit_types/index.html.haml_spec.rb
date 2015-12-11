require 'rails_helper'

RSpec.describe 'visit_types/index.html.haml', type: :view do
  before(:each) do
    @role = FactoryGirl.create(:admin_role)
    @job_type = FactoryGirl.create(:simple_job_type)
    @user = FactoryGirl.create(:user, role_id: @role.id)
    sign_in(@user)

    assign(:visit_types, [
      FactoryGirl.create(:visit_type, title: 'visit types 1'),
      FactoryGirl.create(:visit_type, title: 'visit types 2')
    ])
  end

  it 'renders a list of visit_types' do
    render
    expect(rendered).to match /Visit types 1/
    expect(rendered).to match /Visit types 2/
  end
end
