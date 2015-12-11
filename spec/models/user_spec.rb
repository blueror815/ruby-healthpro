require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#is_deactivated?' do
    before do
      @role = FactoryGirl.create(:admin_role)
      @deactivated_user = FactoryGirl.create(:user, inactive: true, role_id: @role.id)
      @active_user = FactoryGirl.create(:user, email: 'active_user@prohealth.com', role_id: @role.id)
    end
    scenario 'check_deactivated_users' do
      expect(@deactivated_user.deactivated?).to be(true)
    end

    scenario 'check_activated_users' do
      expect(@active_user.deactivated?).to be(false)
    end
  end

  # describe "scrape users from devearo"  do
  #   it "test ::run_user_scraper" do
  #     VCR.use_cassette "User/scrape_users" do
  #       # expect{User.run_user_scraper}.to change(User, :count)
  #     end
  #   end
  # end

  describe 'test role checker methods' do
    context '#admin?' do
      scenario 'approve that user is admin' do
        @admin = Role.find_by(name: 'admin')
        @user = FactoryGirl.create(:user, role_id: @admin.id)
        expect(@user.admin?).to eq(true)
      end
      scenario 'approve that user is not  hr' do
        @admin = Role.find_by(name: 'admin')
        @user = FactoryGirl.create(:user, role_id: @admin.id)
        expect(@user.hr?).to eq(false)
      end
    end

    context '#hr?' do
      scenario 'approve that user is hr' do
        @hr = Role.find_by(name: 'hr')
        @user = FactoryGirl.create(:user, role_id: @hr.id)
        expect(@user.hr?).to eq(true)
      end
      scenario 'approve that user is not  admin' do
        @hr = Role.find_by(name: 'hr')
        @user = FactoryGirl.create(:user, role_id: @hr.id)
        expect(@user.admin?).to eq(false)
      end
    end

    context '#supervisor?' do
      scenario 'approve that user is supervisor' do
        @supervisor = Role.find_by(name: 'supervisor')
        @user = FactoryGirl.create(:user, role_id: @supervisor.id)
        expect(@user.supervisor?).to eq(true)
      end
      scenario 'approve that user is not  admin' do
        @supervisor = Role.find_by(name: 'supervisor')
        @user = FactoryGirl.create(:user, role_id: @supervisor.id)
        expect(@user.admin?).to eq(false)
      end
    end

    context '#office_employee?' do
      scenario 'approve that user is office_employee' do
        @office_employee = Role.find_by(name: 'office_employee')
        @user = FactoryGirl.create(:user, role_id: @office_employee.id)
        expect(@user.office_employee?).to eq(true)
      end
      scenario 'approve that user is not  admin' do
        @office_employee = Role.find_by(name: 'office_employee')
        @user = FactoryGirl.create(:user, role_id: @office_employee.id)
        expect(@user.admin?).to eq(false)
      end
    end

    context '#executive?' do
      scenario 'approve that user is executive' do
        @executive = Role.find_by(name: 'executive')
        @user = FactoryGirl.create(:user, role_id: @executive.id)
        expect(@user.executive?).to eq(true)
      end
      scenario 'approve that user is not  admin' do
        @executive = Role.find_by(name: 'executive')
        @user = FactoryGirl.create(:user, role_id: @executive.id)
        expect(@user.admin?).to eq(false)
      end
    end
  end
end
