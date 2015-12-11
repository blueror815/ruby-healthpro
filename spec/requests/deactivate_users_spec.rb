require 'rails_helper'

RSpec.describe 'DeactivateUsers', type: :request do
  describe 'GET /visits' do
    before do
      @role = Role.find_by(name: 'hr')
      @role.permissions << Permission.where(action_name: 'edit', object_type: 'User')
      @hr_user = FactoryGirl.create(:user, email: '_hr@prohealth.com', role_id: @role.id, password:"123456789")
      @user = FactoryGirl.create(:user, email: 'user@prohealth.com', password:"123456789")

      visit root_path
      fill_in 'user_email', with: @hr_user.email
      fill_in 'user_password', with: '123456789'
      click_on 'Log in'
      expect(current_path).to eq(root_path)
    end

    it 'works! (now write some real specs)' do
      visit edit_user_path(@user.id)
      click_on 'Deactivate'
      expect(current_path).to eq(user_path(@user.id))
      expect(find('body')).to have_content('Deactivated')
    end
  end
end
