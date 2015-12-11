require 'rails_helper'

RSpec.describe 'Patients', type: :request do
  feature 'GET /patients' do
    before do
      @role = Role.find_by(name: 'admin')
      @user = FactoryGirl.create(:user, role_id: @role.id, password: '123456789')
      @agency = FactoryGirl.create(:agency, name: Faker::Lorem.word)
      @another_agency = FactoryGirl.create(:agency, name: Faker::Lorem.word)
      @patient = FactoryGirl.create(:patient, display_name: Faker::Name.name, agency_id: @agency.id)
      visit root_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: '123456789'
      click_on 'Log in'
      expect(current_path).to eq(root_path)
    end

    scenario 'got to patient profile ' do
      visit patient_path(@patient)
      expect(find('body')).to have_content(@patient.display_name)
    end

  end
end
