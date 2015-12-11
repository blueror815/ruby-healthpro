require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  let(:timesheet) { FactoryGirl.create(:timesheet) }
  let(:visits_category) { FactoryGirl.create(:visits_category) }
  let(:visits_custom_form) do
    sections = {
      "0": {
        title: 'state',
        fields: {
          "0": {
            name: 'state',
            type: 'select',
            options: 'paid, pending, unpaid',
            multivalue: '0',
            associated_model: '',
            associated_model_attr: 'id'
          },
          "1": {
            name: 'name',
            type: 'text',
            options: '',
            multivalue: '0',
            associated_model: '',
            associated_model_attr: 'id'
          },
          "2": {
            name: 'date',
            type: 'date',
            options: '',
            multivalue: '0',
            associated_model: '',
            associated_model_attr: 'id'
          },
          "3": {
            name: 'activities',
            type: 'select',
            options: '',
            required: '0',
            multivalue: '1',
            index_display: '0',
            associated_model: '',
            associated_form_attr: "['0']['name']",
            associated_custom_form: 'activity' },
          permissions: {}
        }
      }
    }
    FactoryGirl.create(:custom_form, id: 3, sections: sections)
  end
  let(:visit) { FactoryGirl.create(:form_datum, form_category: visits_category, custom_form: visits_custom_form, model_foreign_key: timesheet.id, sections_data: { '0': { 'state': 'pending' } }) }

  describe "timsheet must belongs to a user " do 
    it 'timsheet valid with user presence' do 
      @timesheet = FactoryGirl.build(:timesheet)
      expect(@timesheet.valid?).to be(true)
    end

    it 'timsheet invalid without user presence' do 
      @timesheet = FactoryGirl.build(:timesheet, user_id: nil)
      expect(@timesheet.valid?).to be(false)
    end
  end
   
  describe '#destroy' do
    describe '#unbind_visits'
    it { expect(timesheet.destroy).to be_truthy }
  end
  # before do
  #   permissions = {}
  #   Role.user_roles.each do |user_role|
  #     permissions[user_role] = {}
  #     User.user_abilities.each do |user_ability|
  #       permissions[user_role][user_ability] = 1
  #     end
  #   end
  #   sections ={
  #     :'0'=>{
  #       title: "first section",
  #       permissions: permissions,
  #       :'fields' =>{
  #         :'0'=>{
  #           name: 'field name',
  #           type: 'text'
  #         }
  #       }
  #     }
  #   }
  #   custom_form_visit = FactoryGirl.create(:custom_form, title: 'visit', permissions: permissions, sections: sections)
  #   custom_form_hourly = FactoryGirl.create(:custom_form, title: 'hours', permissions: permissions, sections: sections)
  #   activity = FactoryGirl.create(:custom_form, title: 'activity', permissions: permissions, sections: sections)

  #   activity_sections_data_1 = {
  #     "0"=>{
  #       "name"=>"some_activity",
  #       "price"=>"200"}
  #     }
  #   activity_sections_data_2 = {
  #     "0"=>{
  #       "name"=>"some_activity",
  #       "price"=>"150"}
  #     }

  #   activity_1 = FactoryGirl.create(:form_datum, custom_form_id: activity.id, sections_data: activity_sections_data_1)
  #   activity_2 = FactoryGirl.create(:form_datum, custom_form_id: activity.id, sections_data: activity_sections_data_2)

  #   visit_sections_data = {
  #     "0"=>{
  #       "a"=>"",
  #       "name"=>"sdafdasf",
  #       "state"=>"pending",
  #       "activities"=>[activity_1.id, activity_2.id],
  #       "total price "=>""
  #       }
  #     }

  #   @visit = FactoryGirl.create(:form_datum, custom_form_id: custom_form_visit.id, sections_data: visit_sections_data)
  #   @visit_2 = FactoryGirl.create(:form_datum, custom_form_id: custom_form_visit.id, sections_data: visit_sections_data)

  #   hour_sections_data = {
  #     "0"=>{
  #       "a"=>"",
  #       "name"=>"sdafdasf",
  #       "state"=>"pending",
  #       "hours"=>"3",
  #       "activities"=>[activity_1.id, activity_2.id],
  #       "total price "=>""
  #       }
  #     }
  #   @hour_record = FactoryGirl.create(:form_datum, custom_form_id: custom_form_hourly.id, sections_data: hour_sections_data)
  # end

  describe '#is_deactivated?'  do
    pending 'add some examples to (or delete) models/timesheet_spec'
  end
end
