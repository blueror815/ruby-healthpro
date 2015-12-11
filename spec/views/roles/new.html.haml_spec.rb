require 'rails_helper'

RSpec.describe 'roles/new', type: :view do
  before(:each) do
    assign(:role, Role.new())
    @permissions = Permission.all
    @role_permission = @role.try(:permission_ids) || []
  end

  it 'renders new role form' do
    render
  end
end
