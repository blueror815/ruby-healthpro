require 'rails_helper'

RSpec.describe "UserCreation", type: :request do
  before do 
    @role = Role.find_by(name: 'hr')
    @role.permissions << Permission.where(action_name: 'edit', object_type: 'User')
    @user = FactoryGirl.create(:user, role_id: @role.id, password:"123456789", job_type_id: JobType.first.id)
    visit root_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: '123456789'
    click_on 'Log in'
    expect(current_path).to eq(root_path)
  end

  feature 'POST /user_creation' do
    context 'create user with invalid data' do
      scenario 'create with non_matched password confirmation' do
        visit new_user_registration_path
        fill_in 'user_email', with: 'some_user@prohealth.com'
        fill_in 'user_display_name', with: 'some user'
        click_on 'Save'
        expect(find('body')).to have_content "Password can't be blank"
      end

      scenario 'create with empty password confirmation' do
        visit new_user_registration_path
        fill_in 'user_email', with: 'some_user@prohealth.com'
        fill_in 'user_display_name', with: 'some user'
        fill_in 'user_password', with: '123456789'
        fill_in 'user_password_confirmation', with: '12345678'
        click_on 'Save'
        expect(find('body')).to have_content "Password confirmation doesn't match Password"
      end
    end
  end

  context 'create user with invalid data' do
    scenario 'create ' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'some_user@prohealth.com'
      fill_in 'user_display_name', with: 'some user'
      fill_in 'user_password', with: '123456789'
      fill_in 'user_password_confirmation', with: '123456789'
      click_on 'Save'
      expect(find('body')).to have_content 'User was successfully created.'
    end
  end
end
