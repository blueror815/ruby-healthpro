require 'rails_helper'

RSpec.describe 'Reimbursements', type: :request do
  before do
    @role = Role.find_by(name: 'admin')
    @user = FactoryGirl.create(:user, email: 'user@prohealth.com', role_id: @role.id, password: '123456789')
    login_as @user
  end

  describe 'GET /reimbursements' do
    it 'works! (now write some real specs)' do
      get reimbursements_path
      expect(response).to have_http_status(200)
    end
  end
end
