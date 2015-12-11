  require 'rails_helper'

RSpec.describe 'CoverageAreas', type: :request do
  before do
      @role = Role.find_by(name: 'admin')
      @user = FactoryGirl.create(:user, role_id: @role.id, password: '123456789')
      visit root_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: '123456789'
      click_on 'Log in'
      expect(current_path).to eq(root_path)
  end

  describe 'GET /coverage_areas' do
    it 'works! (now write some real specs)' do
      get coverage_areas_path
    end
  end
end
