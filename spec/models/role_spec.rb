
require 'rails_helper'

RSpec.describe Role, type: :model do
  before do
    @admin_role = FactoryGirl.create(:admin_role)
    @user_role = FactoryGirl.create(:user_role)
    @user = FactoryGirl.create(:user, role_id: @admin_role.id)
  end

  describe '#has_no_assigned_users?'  do
    context 'without assigned users ' do
      scenario 'triggers has_no_assigned_users?' do
        expect(@admin_role.has_no_assigned_users?).to be(false)
      end
    end

    context 'with assigned users ' do
      scenario 'triggers has_no_assigned_users?' do
        expect(@user_role.has_no_assigned_users?).to be(true)
      end
    end
  end
end
