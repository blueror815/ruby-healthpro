require 'rails_helper'

RSpec.describe 'Departments', type: :request do
  before do
    @role = Role.find_by(name: 'admin')
    @user = FactoryGirl.create(:user, role_id: @role.id, password: '123456789')
    visit root_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: '123456789'
    click_on 'Log in'
    expect(current_path).to eq(root_path)
  end

  describe 'GET /departments' do
    it 'works! (now write some real specs)' do
      get departments_path
      # expect(page).to have_content("Departments")
      # expect(response).to have_http_status(200)
    end
  end
end
