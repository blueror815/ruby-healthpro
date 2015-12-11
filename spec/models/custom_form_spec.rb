
require 'rails_helper'

RSpec.describe CustomForms::CustomForm do
  before do
    @permissions = {}
    Role.user_roles.each do |user_role|
      @permissions[user_role] = {}
      User.user_abilities.each do |user_ability|
        @permissions[user_role][user_ability] = 1
      end
    end
  end

  describe '#validation test #fields' do
    before do
      @valid_sections = {
        '0': {
          title: 'first section',
          permissions: @permissions,
          'fields': {
            '0': {
              name: 'field name',
              type: 'text'
            }
          }
        }
      }
      @invalid_sections = {
        '0': {
          title: 'first section',
          permissions: @permissions
        }
      }
      @invalid_sections_without_field_name = {
        '0': {
          title: 'first section',
          permissions: @permissions,
          'fields': {
            '0': {
              name: '',
              type: 'text'
            }
          }
        }
      }

      @dublicated_field_name = {
        '0': {
          title: 'first section',
          permissions: @permissions,
          'fields': {
            '0': {
              name: 'field name',
              type: 'text'
            },
            '1': {
              name: 'field name',
              type: 'text'
            }
          }
        }
      }
    end
    it 'does not allow field_name to be empty' do
      custom_form = FactoryGirl.build(:custom_form, title: 'custom', permissions: @permissions, sections: @invalid_sections)
      custom_form.valid?
      expect(custom_form.errors[:empty_section].size).to eq(1)
      expect(custom_form.errors[:empty_section].first).to eq('One of your sections has no fields')
    end

    it 'does not allow field_name to be empty' do
      custom_form = FactoryGirl.build(:custom_form, title: 'custom', permissions: @permissions, sections: @invalid_sections_without_field_name)
      custom_form.valid?
      expect(custom_form.errors[:field_name].size).to eq(1)
      expect(custom_form.errors[:field_name].first).to eq("One of your field's name is empty")
    end

    it 'does not allow dublicated field_name within the same section ' do
      custom_form = FactoryGirl.build(:custom_form, title: 'custom', permissions: @permissions, sections: @dublicated_field_name)
      custom_form.valid?
      expect(custom_form.errors[:duplicated_field_name].size).to eq(1)
      expect(custom_form.errors[:duplicated_field_name].first).to eq('duplicated for the same seciton')
    end
  end

  describe '#validation test #fields' do
    before do
      @valid_sections = {
        '0': {
          title: 'first section',
          permissions: @permissions,
          'fields': {
            '0': {
              name: 'field name',
              type: 'text'
            }
          }
        }
      }
      @invalid_sections = {
        '0': {
          title: '',
          permissions: @permissions,
          'fields': {
            '0': {
              name: 'field name',
              type: 'text'
            }
          }
        }
      }
    end
    it 'does not allow section name to be empty' do
      custom_form = FactoryGirl.build(:custom_form, title: 'custom', permissions: @permissions, sections: @invalid_sections)
      custom_form.valid?
      expect(custom_form.errors[:section_title].size).to eq(1)
      expect(custom_form.errors[:section_title].first).to eq("One of your section's name is empty")
    end
  end
end
