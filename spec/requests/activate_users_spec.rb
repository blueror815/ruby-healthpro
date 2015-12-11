require 'rails_helper'

RSpec.describe 'ActivateUsers', type: :request do
  feature 'post /activate_users success ' do
    before do
      @role = Role.find_by(name: 'hr')
      @role.permissions << Permission.where(action_name: 'edit', object_type: 'User')
      @user_role = Role.find_by(name: 'user')
      @hr_user = FactoryGirl.create(:user, role_id: @role.id, password:"123456789")
      @user = FactoryGirl.create(:user, email: 'user@prohealth.com', role_id: @user_role.id, password:"123456789", inactive: true, job_type_id: JobType.first.id)
      FactoryGirl.create(:form_datum, custom_form_id: CustomForms::CustomForm.find_by(title: 'HR Form').id, user_id: @user.id, creator_user_id: 1)

      visit root_path
      fill_in 'user_email', with: @hr_user.email
      fill_in 'user_password', with: '123456789'
      click_on 'Log in'
      expect(current_path).to eq(root_path)
    end

    scenario 'works! (now write some real specs)' do
      visit edit_user_path(@user.id)
      click_on 'Activate'
      expect(current_path).to eq(user_path(@user.id))
      expect(find('body')).to_not have_content("Deactivated")
    end
  end
end
