require 'rails_helper'

RSpec.describe AdminConfigurationsController, type: :controller do
  before do
    @role = Role.find_by(name: 'admin')
    @user = FactoryGirl.create(:user, role_id: @role.id)
    sign_in(@user)
  end

  describe "GET #update_payroll_dates" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
