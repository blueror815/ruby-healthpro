require 'rails_helper'

RSpec.describe TimesheetsHelper, type: :helper do
  before do
    @role = Role.find_by(name: 'admin')
    @job_type = FactoryGirl.create(:simple_job_type, hour_price: { 'normal' => '10', 'overtime' => '25', 'outdoor' => '15' }, payment_method_ids: [1, 2, 3], salary_amount: 21_000)
    @user = FactoryGirl.create(:user, role_id: @role.id, job_type_id: @job_type.id)
    sign_in(@user)

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
    custom_form_visit = FactoryGirl.create(:custom_form, title: 'visit', permissions: permissions, sections: sections)
    custom_form_hourly = FactoryGirl.create(:custom_form, title: 'hours', permissions: permissions, sections: sections)
    activity = FactoryGirl.create(:custom_form, title: 'activity', permissions: permissions, sections: sections)

    activity_sections_data_1 = {
      '0' => {
        'name' => 'some_activity',
        'price' => '200' }
    }
    activity_sections_data_2 = {
      '0' => {
        'name' => 'some_activity',
        'price' => '150' }
    }

    activity_1 = FactoryGirl.create(:form_datum, custom_form_id: activity.id, sections_data: activity_sections_data_1, creator_user_id: @user.id)
    activity_2 = FactoryGirl.create(:form_datum, custom_form_id: activity.id, sections_data: activity_sections_data_2, creator_user_id: @user.id)

    visit_sections_data = {
      '0' => {
        'a' => '',
        'name' => 'sdafdasf',
        'state' => 'pending',
        'activities' => [activity_1.id, activity_2.id],
        'total price ' => ''
      }
    }

    @visit = FactoryGirl.create(:form_datum, custom_form_id: custom_form_visit.id, sections_data: visit_sections_data, creator_user_id: @user.id)
    @visit_2 = FactoryGirl.create(:form_datum, custom_form_id: custom_form_visit.id, sections_data: visit_sections_data, creator_user_id: @user.id)

    hour_sections_data = {
      '0' => {
        'a' => '',
        'name' => 'sdafdasf',
        'state' => 'pending',
        'hours' => '3',
        'total price ' => '',
        'hours type' => 'overtime'
      }
    }
    @hour_record = FactoryGirl.create(:form_datum, custom_form_id: custom_form_hourly.id, sections_data: hour_sections_data, creator_user_id: @user.id)
  end
  # TODO: reafactor after timesheets restructured
  # describe "helper #price_sum" do
  #   it 'test price sum ' do
  #     expect(helper.price_sum(@visit)).to eq(350)
  #   end
  # end

  # describe "helper #timesheet_total_price" do
  #   it 'test timesheet_total_price' do
  #     expect(helper.timesheet_total_price([[@visit, @visit_2], [@hour_record], @user.job_type.salary_amount])).to eq(21775)
  #   end
  # end
end
