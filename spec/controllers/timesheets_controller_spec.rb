require 'rails_helper'

RSpec.feature TimesheetsController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers
  let(:valid_session) { {} }

   before do 
    @role = Role.find_by(name: 'admin')
    @role.permissions << Permission.where(action_name: 'show_all_timesheets', object_type: 'Timesheet')
    @job_type = FactoryGirl.create(:simple_job_type)
    @user = FactoryGirl.create(:user, role_id: @role.id, job_type_id: @job_type.id)
    AdminConfiguration.create(title: 'payroll', configurations: {"period"=>{"days"=>"14", "hours"=>"3"},
    "admission_allowance"=>{"days"=>"2", "hours"=>"3"},
    "submission_allowance"=>{"days"=>"1", "hours"=>"3"}})
    @payroll = FactoryGirl.create(:payroll)
    success, failure = Delayed::Worker.new.work_off #create tiemsheets
    sign_in(@user)
    @timesheet = Timesheet.find_by(user_id: @user.id)
  end

  describe 'GET #show_user_timesheet' do
    it 'returns http success' do
      timesheets = @user.timesheets
      get :index, {user_id: @user.id}, valid_session
      expect(assigns(:timesheets)).to eq(timesheets)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested timesheet as @timesheet' do
      timesheet = @timesheet
      get :show, { id: timesheet.to_param }, valid_session
      expect(assigns(:timesheet)).to eq(timesheet)
    end
  end

  describe 'GET #show_latest' do
    it 'redirects to tha path of latest timesheet' do
      response = get :show_latest, { id: @timesheet.to_param }, valid_session
      expect(response).to redirect_to action: :show,
                                      id: @timesheet.id
    end
  end

  context 'timesheet states test' do
    it 'has created state by default' do
      expect(@timesheet.state).to eq('created')
    end
  end

  context 'jobs testing' do
    it 'creates a new payroll at the end of the current payroll' do
      expect(Delayed::Job.count).to eq(3) #initally, 2 jobs for state change, 1 job for payroll creation
      travel_to @payroll.end_date + 1.minute
      expect{Delayed::Worker.new.work_off(1)}.to change(Payroll, :count).by(1) #payroll creation job
      travel_back
    end

    it 'changes timesheets state to submitted/admitted after submission/admitted deadline passes' do
      travel_to @payroll.submission_date + 1.minute
      s, f = Delayed::Worker.new.work_off #worker for submission date state change
      expect(Timesheet.order(created_at: :asc).limit(User.count).map(&:state).uniq[0]).to eq 'submitted'
      travel_to @payroll.admission_date + 1.minute
      Delayed::Worker.new.work_off #worker for admission date state change
      expect(Timesheet.order(created_at: :asc).limit(User.count).map(&:state).uniq[0]).to eq 'admitted'
      travel_back
    end
  end
end
