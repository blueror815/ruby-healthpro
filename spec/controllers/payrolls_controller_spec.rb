require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe PayrollsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # payroll. As you add validations to payroll, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      start_date: Time.now - 1.day
    }
  end

  let(:overlaped_unvalid_attributes) do
    {
      start_date: Time.now + 2.week
    }
  end

  let(:invalid_attributes) do
    {
      start_date: ''
    }
  end

  let(:date_range_invalid_attributes) do
    {
      start_date: Time.now
    }
  end
  let(:valid_attributes) {{
    start_date: Time.now - 1.day
    }}

  let(:overlaped_unvalid_attributes) {{
    start_date: Time.now + 2.week
    }}

  let(:invalid_attributes) {{
      start_date: ''
  }}

  let(:date_range_invalid_attributes) {{
      start_date: Time.now
  }}

  before do
    AdminConfiguration.create(title: 'payroll', configurations: {"period"=>{"days"=>"14", "hours"=>"3"},
    "admission_allowance"=>{"days"=>"2", "hours"=>"3"},
    "submission_allowance"=>{"days"=>"1", "hours"=>"3"}})
    @role = Role.find_by(name: 'admin')
    user = FactoryGirl.create(:user, role_id: @role.id)
    sign_in(user)
  end
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Payroll. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "POST #create" do
    context "with valid params" do
    #   it "creates a new Payroll" do
    #     expect {
    #       post :create, {payroll: valid_attributes}, valid_session
    #     }.to change(Payroll, :count).by(1)
    #   end

    #   it "assigns a newly created payroll as @payroll" do
    #     post :create, {payroll: valid_attributes}, valid_session
    #     expect(assigns(:payroll)).to be_a(Payroll)
    #     expect(assigns(:payroll)).to be_persisted
    #   end

    #   it "redirects to the created payroll" do
    #     post :create, {payroll: valid_attributes}, valid_session
    #     expect(response).to redirect_to(payrolls_path)
    #   end
    # end

    # context "with invalid params" do
    #   it "assigns a newly created but unsaved payroll as @payroll" do
    #     post :create, {payroll: invalid_attributes}, valid_session
    #     expect(assigns(:payroll)).to be_a_new(Payroll)
    #   end

    #   it "re-renders the 'new' template" do
    #     post :create, {payroll: invalid_attributes}, valid_session
    #     expect(response).to render_template("new")
    #   end

    #   it "without start_date" do
    #     post :create, {payroll: {end_date:Time.now}}, valid_session
    #     expect(response).to render_template("new")
    #   end


      # doesn't apply anymore
      # it "without end_date" do
      #   post :create, {:payroll => {start_date:Time.now}}, valid_session
      #   expect(response).to render_template("new")
      # end

      # doesn't apply anymore
      # it "with start_date after end_date" do
      #   post :create, {:payroll => date_range_invalid_attributes}, valid_session
      #   expect(response).to render_template("new")
      #   expect(assigns(:payroll).errors.full_messages.first).to eq('Start date must be before end date')
      # end
    end

    context "with time overlap" do
      # it "overlap in payrolls creation" do
      #   post :create, {payroll: valid_attributes}, valid_session
      #   expect(assigns(:payroll)).to be_a(Payroll)
      #   expect(assigns(:payroll)).to be_persisted
      #   post :create, {payroll: valid_attributes}, valid_session
      #   expect(assigns(:payroll)).to be_a_new(Payroll)
      #   expect(assigns(:payroll).errors.full_messages.first).to eq('Start date overlaps with another record')
      # end
      # doesn't apply anymore
      # it "payroll starts at the same day another one ends " do
      #   post :create, {:payroll => valid_attributes}, valid_session
      #   expect(assigns(:payroll)).to be_a(Payroll)
      #   expect(assigns(:payroll)).to be_persisted
      #   post :create, {:payroll => overlaped_unvalid_attributes}, valid_session
      #   expect(assigns(:payroll)).to be_a_new(Payroll)
      #   expect(assigns(:payroll).errors.full_messages.first).to eq('Start date overlaps with another record')
      # end

      # doesn't apply anymore
      # it "payroll end at the same day another one starts " do
      #   post :create, {:payroll => overlaped_unvalid_attributes}, valid_session
      #   expect(assigns(:payroll)).to be_a(Payroll)
      #   expect(assigns(:payroll)).to be_persisted
      #   post :create, {:payroll => valid_attributes}, valid_session
      #   expect(assigns(:payroll)).to be_a_new(Payroll)
      #   expect(assigns(:payroll).errors.full_messages.first).to eq('Start date overlaps with another record')
      # end
    end

    context 'jobs testing' do
      before do
        post :create, {:payroll => valid_attributes}, valid_session
      end

      it 'creates a timesheet for each user after payroll craation and dispatches state change jobs' do
        expect {
          Delayed::Worker.new.work_off #create timesheets
        }.to change(Timesheet, :count).by(User.count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @payroll = FactoryGirl.create(:payroll)
    end
    it 'destroys the requested payroll' do
      payroll = @payroll
      expect do
        delete :destroy, { id: payroll.to_param }, valid_session
      end.to change(Payroll, :count).by(-1)
    end

    it 'redirects to the payrolls list' do
      payroll = @payroll
      delete :destroy, { id: payroll.to_param }, valid_session
      expect(response).to redirect_to(payrolls_url)
    end
  end
end