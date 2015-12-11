require 'rails_helper'

RSpec.describe "FieldTypes", type: :request do
  # routes { CustomForms::Engine.routes }
  before do
    @role = Role.find_by(name: 'admin')
    @user = FactoryGirl.create(:user, role_id: @role.id, password: '123456789')
    visit root_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: '123456789'
    click_on 'Log in'
  end
  describe "GET /field_types" do
    it "works! (now write some real specs)" do
      get custom_forms.field_types_path
      # expect(response).to have_http_status(200)
    end
  end
end
