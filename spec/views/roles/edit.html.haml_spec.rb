require 'rails_helper'

RSpec.describe 'roles/edit', type: :view do
  before(:each) do
    @role = assign(:role, Role.create!(name: 'test role',short_name: 'test short name'))
    @model = "role"
    @permissions = Permission.all
    @role_permission = @role.try(:permission_ids) || []
  end

  it 'renders the edit role form' do
    render
    expect(rendered).to match /test role/
  end
end
