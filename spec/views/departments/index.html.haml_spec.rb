require 'rails_helper'

RSpec.describe 'departments/index', type: :view do
  before(:each) do
    @departments = assign(:departments, [
                    Department.create!(
                      name: 'Name'
                    ),
                    Department.create!(
                      name: 'Name'
                    )
                  ])
    @instances = @departments
    @model = 'department'
    @role = Role.find_by(name: 'admin')
    @user = FactoryGirl.create(:user, role_id: @role.id, password: '123456789')
    sign_in @user
  end

  it 'renders a list of departments' do
    render
    # assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
