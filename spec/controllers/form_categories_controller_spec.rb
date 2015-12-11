require 'rails_helper'

RSpec.feature CustomForms::FormCategoriesController, type: :controller do
  routes { CustomForms::Engine.routes }

  let(:valid_session) { {} }

  before do
    @role = FactoryGirl.create(:admin_role)
    @user = FactoryGirl.create(:user, role_id: @role.id)
    sign_in(@user)
    @admin_cat = FactoryGirl.create(:admin_category)
    @visit_cat = FactoryGirl.create(:visits_category)
    permissions = {}
    Role.user_roles.each do |user_role|
      permissions[user_role] = {}
      User.user_abilities.each do |user_ability|
        permissions[user_role][user_ability] = 1
      end
    end
    sections = {
      '0': {
        title: 'first section',
        permissions: permissions,
        'fields': {
          '0': {
            name: 'field name',
            type: 'text'
          }
        }
      }
    }
    FactoryGirl.create(:custom_form, title: 'first_custom', permissions: permissions, sections: sections, form_category_id: @admin_cat.id)
  end

  describe 'DELETE #destroy' do
    context 'with assigned users' do
      it 'destroys the requested job stops ' do
        expect do
          delete :destroy, { id: @admin_cat.id }, valid_session
        end.to_not change(FormCategory, :count)
      end
    end

    context 'without assigned users ' do
      it 'destroys the requested job' do
        FactoryGirl.create(:simple_job_type, job_class: 'another job')
        expect do
          delete :destroy, { id: @visit_cat.id }, valid_session
        end.to change(FormCategory, :count).by(-1)
      end
    end
  end
end
