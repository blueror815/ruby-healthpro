require 'rails_helper'

RSpec.describe 'Diseases', type: :request do
  feature 'GET /diseases' do
    before do
      @role = Role.find_by(name: 'HR')
      @user_role = FactoryGirl.create(:user_role)
      @hr_user = FactoryGirl.create(:user, role_id: @role.id, password: '123456789')
      @user = FactoryGirl.create(:user, email: 'user@prohealth.com', role_id: @user_role.id, password: '123456789')
      visit root_path
      fill_in 'user_email', with: @hr_user.email
      fill_in 'user_password', with: '123456789'
      click_on 'Log in'
      expect(current_path).to eq(root_path)
    end

    # scenario "works! (now write some real specs)" do
    #   get diseases_path
    #   expect(response).to have_http_status(200)
    # end
  end
end
