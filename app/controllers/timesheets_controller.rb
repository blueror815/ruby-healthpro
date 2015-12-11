class TimesheetsController < ApplicationController
  before_action :set_user, only: [:index, :show, :update_task_state, :update, :submit, :admit, :pay]
  before_action :set_timesheet, only: [:show, :update_task_state, :update, :submit, :admit, :pay]

  include TimesheetsHelper

  def index
    if @user
      if @user.id == current_user.id
        @timesheets = @user.timesheets.includes(:payroll)
      else
        authorize! :view_all, Timesheet
        @timesheets = current_user.timesheets.includes(:payroll, :user, :visits, :hours, :line_items)
      end
    else
      authorize! :view_all, Timesheet
      @timesheet_type = params[:timesheets_type] || 'created'

      if params[:timesheets_type]
        if params[:timesheets_type] == 'finalized'
          @timesheets = Timesheet.where(state:['2', '3']).includes(:payroll, :user, :visits, :hours, :line_items)
        else
          @timesheets = Timesheet.send(@timesheet_type.to_sym).includes(:payroll, :user, :visits, :hours, :line_items)
        end
      else
        @timesheets = Timesheet.includes(:payroll, :user, :visits, :hours, :line_items)
      end
    end
    set_events_array
  end

  def show
    @recent_visits = Visit.user_visits(current_user.id)
    user = @user ? @user : current_user
    @pending_on_calls, @approved_on_calls = [], []
    @pending_reimb , @approved_reimb = [], []
    @unpaid_visits, @pending_visits, @approved_visits, @admitted_visits = [], [], [], []

    # visit payment method 
    if user.job_type.payment_method_ids.include?('1')
      @unpaid_visits =  user.assigned_visits.where(progress_state: 'visited')
      @pending_visits =  @timesheet.visits.where(progress_state: 'pending')
      @approved_visits = @timesheet.visits.where(progress_state: 'approved')
      @admitted_visits =  @timesheet.visits.where(progress_state: 'admited')
      @rejected_visits =  @timesheet.visits.where(progress_state: 'rejected')
    end

    # hourly payment method 
    if user.job_type.payment_method_ids.include?('2')
      @unpaid_hours =  user.logged_hours.where(progress_state: 'logged')
      @pending_hours = @timesheet.hours.where(progress_state: 'pending')
      @approved_hours = @timesheet.hours.where(progress_state: 'approved')
      @admitted_hours =  @timesheet.hours.where(progress_state: 'admited')
      @rejected_hours =  @timesheet.hours.where(progress_state: 'rejected')
    end

    if user.job_type.payment_method_ids.include?('5')
      @unpaid_on_calls = user.on_calls.where(progress_state: 'logged')
      @pending_on_calls = @timesheet.line_items.on_calls.where(progress_state: 'pending')
      @approved_on_calls = @timesheet.line_items.on_calls.where(progress_state: 'approved')
      @admitted_on_calls =  @timesheet.line_items.on_calls.where(progress_state: 'admited')
      @rejected_on_calls =  @timesheet.line_items.on_calls.where(progress_state: 'rejected')
    end

    if user.job_type.payment_method_ids.include?('6')
      @unpaid_reimb = user.reimbursement_timesheets.where(progress_state: 'logged')
      @pending_reimb = @timesheet.line_items.reimb.where(progress_state: 'pending')
      @approved_reimb = @timesheet.line_items.reimb.where(progress_state: 'approved')
      @admitted_reimb =  @timesheet.line_items.reimb.where(progress_state: 'admited')
      @rejected_reimb =  @timesheet.line_items.reimb.where(progress_state: 'rejected')
    end
    @user_bonus = @timesheet.line_items.bonus.last
  end

  def update
    respond_to do |format|
      if @timesheet.update(timesheet_params)
        if params[:redirect_url]
         format.js {redirect_to params[:redirect_url]}
         # format.js { render :js => "window.location.href = '#{params[:redirect_url]}'" }
        else
          format.html { redirect_to @user.nil? ? @timesheet : user_timesheet_path(@user, @timesheet), flash: {success: 'Timesheet was successfully updated.'} }
        end
        format.json { render :show, status: :ok, location: @timesheet }
      else
        format.html { render :edit }
        format.json { render json: @timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def show_latest
    latest_timesheet = current_user.timesheets.try(:last)
    if latest_timesheet
      redirect_to timesheet_path(latest_timesheet)
    end
  end

  def create_timesheet
    latest_payroll = Payroll.last
    user = User.find(params[:user_id])
    if latest_payroll && user
      @timesheet = latest_payroll.timesheets.create(user_id: user.id)
    end
    redirect_to timesheet_path(@timesheet)
  end

  def update_task_state
    user = @user ? @user : current_user
    if params[:task_id]
      params[:task_id].each do |task_id|
        if params[:task_type] == 'hour'
          @task = user.logged_hours.find(task_id)
        elsif params[:task_type] == 'on_call'
          @task = user.logged_on_calls.find(task_id)
        elsif params[:task_type] == 'reimbursement_timesheet'
          @task = user.logged_reimb.find(task_id)
        else
          @task = user.assigned_visits.find(task_id)
        end
        @task.progress_state = params[:state]
        unless ['visited', 'logged'].include? @task.progress_state 
          if @task.class.name == "OnCall"
            li = LineItem.where(payable_id: @task.id, payable_type: "OnCall", timesheet_id: @timesheet.id).first_or_create
            li.progress_state = params[:state]
            li.save!
          elsif @task.class.name == "ReimbursementTimesheet"
            li = LineItem.where(payable_id: @task.id, payable_type: "ReimbursementTimesheet", timesheet_id: @timesheet.id).first_or_create
            li.progress_state = params[:state]
            li.save!
          else
            @task.timesheet = @timesheet 
          end
        else
          #TODO_PROHEALTH this condition will be removed when move to line item
          if @task.class.name == "OnCall"
            LineItem.where(payable_id: @task.id, payable_type: "OnCall", timesheet_id: @timesheet.id).delete_all
          elsif @task.class.name == "ReimbursementTimesheet"
            LineItem.where(payable_id: @task.id, payable_type: "ReimbursementTimesheet", timesheet_id: @timesheet.id).delete_all
          else
            @task.timesheet = nil
          end
        end
        @task.save!
      end
    end
    if @user
      redirect_to user_timesheet_path(@user, @timesheet)
    else
      redirect_to timesheet_path(@timesheet)
    end
  end

  def submit
    authorize! :submit, @timesheet
    if submittable?(@timesheet)
      params[:timesheet] = {state: 'submitted'}
      update
      visits_to_approve = @timesheet.visits.select do |visit|
        visit.reimbursements_visits.where('action_count > 0').count == 0
      end
      visits_to_approve.each do |visit|
        visit.update(progress_state: "approved")
      end
      notify @timesheet, User.admitters - [current_user]
    else
      respond_to do |format|
        format.html { redirect_to @user.nil? ? @timesheet : user_timesheet_path(@user, @timesheet), flash: {error: 'Timesheet can not be submitted.'} }
      end
    end
  end

  def admit
    authorize! :admit, Timesheet
    if admittable?(@timesheet, @user)
      @timesheet.state = 3
      if @timesheet.save!
        #update approved visit's and hour's status 
        @timesheet.visits.where(progress_state: 'approved').each do |visit|
          visit.progress_state = 'admited'
          visit.save!
        end
        @timesheet.hours.where(progress_state: 'approved').each do |hour|
          hour.progress_state = 'admited'
          hour.save!
        end

        @timesheet.line_items.on_calls.where(progress_state: 'approved').each do |on_call_li|
          payable_obj = on_call_li.payable
          on_call_li.update_attribute(:progress_state,  'admited')
          payable_obj.update_attribute(:progress_state,  'admited')
        end

        @timesheet.line_items.reimb.where(progress_state: 'approved').each do |reimb_li|
          payable_obj = reimb_li.payable
          reimb_li.update_attribute(:progress_state,  'admited')
          payable_obj.update_attribute(:progress_state,  'admited')
        end

        #update pending visit's and hour's status 
        @timesheet.visits.where(progress_state: 'pending').each do |visit|
          visit.progress_state = 'visited'
          visit.timesheet = nil
          visit.save!
        end

        @timesheet.hours.where(progress_state: 'pending').each do |hour|
          hour.progress_state = 'logged'
          hour.timesheet = nil
          hour.save!
        end

        @timesheet.line_items.on_calls.where(progress_state: 'pending').each do |on_call_li|
          on_call_li.payable.update_attribute(:progress_state,  'logged')
          on_call_li.destroy
        end

        @timesheet.line_items.reimb.where(progress_state: 'pending').each do |reimb_li|
          reimb_li.payable.update_attribute(:progress_state,  'logged')
          reimb_li.destroy
        end

        notify @timesheet, @timesheet.user, 'admit_notify_owner' if @timesheet.user != current_user
        notify @timesheet, User.payers - [current_user], 'admit_notify_payers'
      end
      if params[:pay] == "true"
        params[:redirect_url] = main_app.timesheets_path(timesheets_type: params[:table_type])
        pay
      else
        if @user
          redirect_to user_timesheet_path(@user, @timesheet)
        else
          redirect_to timesheet_path(@timesheet)
        end
      end
      
    else
      respond_to do |format|
        format.html { redirect_to @user.nil? ? @timesheet : user_timesheet_path(@user, @timesheet), flash: {error: 'Timesheet can not be admitted.'} }
      end
    end
  end

  def pay
    authorize! :pay, Timesheet
    if payable?(@timesheet)
      params[:timesheet] = {state: 'paid'}
      @timesheet.update_total_paid
      params[:redirect_url] = params[:redirect_to] if params[:redirect_to]
      update
      notify @timesheet, @timesheet.user if @timesheet.user != current_user
    else
      respond_to do |format|
        format.html { redirect_to @user.nil? ? @timesheet : user_timesheet_path(@user, @timesheet), flash: {error: 'Timesheet can not be paid.'} }
      end
    end
  end

  def send_email_to_owner
    Timesheet.delay.send_email_to_owner(params[:id])
    respond_to do |format|
       format.js { render :nothing => true }
    end
  end

  private
    def set_user
      if params[:user_id]
        @user = User.find(params[:user_id]) 
      end
    end

      # Use callbacks to share common setup or constraints between actions.
    def set_timesheet
      @timesheet = if @user
        @user.timesheets.find(params[:id])
      else
        current_user.timesheets.find(params[:id])
      end
    end

    # create array of timesheets data to be sent as param to js fullcalender function to apply fullcalender in the view
    def set_events_array
      @events_array = []
      @timesheets.each do |timesheet|
        @events_array << { title: "Timesheet ##{timesheet.id}",
                           start: timesheet.payroll.start_date.strftime('%Y, %m, %d'),
                           end: (timesheet.payroll.end_date + 1).strftime('%Y, %m, %d'),
                           allDay: true }
      end
    end

    def timesheet_params
      params.require(:timesheet).permit(:notification, :user_id, :state)
    end
end
