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
    @sections = {
      '0': {
        title: 'first section',
        permissions: @permissions,
        'fields': {
          '0': {
            name: 'field name',
            type: 'text',
            required: '1'
          }
        }
      }
    }
  end

  it 'does not allow field_name to be empty' do
    custom_form = FactoryGirl.create(:custom_form, title: 'custom', permissions: @permissions, sections: @sections)
    sections_data = {}
    custom_form.sections.each do |k, v|
      fields = {}
      v['fields'].values.each do |field|
        fields[field['name']] = ''
      end
      sections_data[k] = fields
    end
    form_datum = CustomForms::FormDatum.new(custom_form_id: custom_form.id, sections_data: sections_data)
    expect(form_datum.valid?).to be_falsy
  end
end
