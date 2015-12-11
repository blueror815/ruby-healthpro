require 'rails_helper'

 RSpec.describe "Visits", type: :request do
  describe "GET /visits" do
    before do
      @role = Role.find_by(name: 'admin')
      @admin = FactoryGirl.create(:user, password: '123456789' ,role_id: @role.id)
      @department = FactoryGirl.create(:department)
      @reimbursement = FactoryGirl.create(:reimbursement, title: 'Inject')
      @visit_type = FactoryGirl.create(:visit_type, department_ids: [@department.id], reimbursement_ids: [@reimbursement.id])
      @user_role = FactoryGirl.create(:user_role)
      @user = FactoryGirl.create(:user, email: 'user@prohealth.com', role_id: @user_role.id, password:"123456789", display_name: 'normal_user' , inactive: true, department_ids:[ @department.id])
    end

    it "works! (now write some real specs)" do
      visit root_path
      fill_in 'user_email', with: @admin.email
      fill_in 'user_password', with: '123456789'
      click_on 'Log in'
      expect(current_path).to eq(root_path)
      visit new_visit_path
      # expect(page.has_select?('visit[assignee_id]', :options => [''])).to be(true)
      find(:xpath,'//*[@id="visit_visit_type_id"]').find(:xpath, 'option[2]').select_option
      # expect(page).to_not have_content(page.has_select?('visit[assignee_id]', :options => ['']))
    end
  end
end
