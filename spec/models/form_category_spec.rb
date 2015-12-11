
require 'rails_helper'

RSpec.describe Role, type: :model do
  before do
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

  describe '#has_no_forms?' do
    context 'without assigned users ' do
      scenario 'triggers has_no_forms?' do
        expect(@admin_cat.has_no_forms?).to be(false)
      end
    end

    context 'with assigned users ' do
      scenario 'triggers has_no_forms?' do
        expect(@visit_cat.has_no_forms?).to be(true)
      end
    end
  end
end
