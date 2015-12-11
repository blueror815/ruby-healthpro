require 'rails_helper'

RSpec.describe 'coverage_areas/index', type: :view do
  before(:each) do
    @role = Role.find_by(name: 'admin')
    @user = FactoryGirl.create(:user, email: 'user@prohealth.com', role_id: @role.id, password: '123456789')
    sign_in @user

    assign(:coverage_areas, [
      CoverageArea.create!(
        name: 'Name'
      ),
      CoverageArea.create!(
        name: 'Name'
      )
    ])
  end

  it 'renders a list of coverage_areas' do
    render
    assert_select 'tr>td>a', text: 'Name'.to_s, count: 2
  end
end
