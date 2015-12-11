require 'rails_helper'

RSpec.describe 'roles/index', type: :view do
  before(:each) do
    assign(:roles, [
      Role.create!(name: 'test role1', short_name: 'test short name1'),
      Role.create!(name: 'test role2', short_name: 'test short name2')
    ])
  end

  it 'renders a list of roles' do
    render
  end
end
