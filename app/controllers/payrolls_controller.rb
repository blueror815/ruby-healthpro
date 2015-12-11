class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :edit, :update, :destroy]
  before_action :set_payroll_configurations, only: [:new, :edit]

  # GET /payrolls
  # GET /payrolls.json
  def index
    @payrolls = Payroll.all
    reports_data(@payrolls)
  end

  # GET /payrolls/1
  # GET /payrolls/1.json
  def show
    @timesheets = @payroll.timesheets.includes(:payroll, :user)
    reports_data([@payroll])
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
  end

  # GET /payrolls/1/edit
  def edit
  end

  # POST /payrolls
  # POST /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)

    respond_to do |format|
      if @payroll.save
        format.html { redirect_to payrolls_path, flash: { success: 'Payroll was successfully created.' } }
        format.json { render :show, status: :created, location: @payroll }
      else
        set_payroll_configurations
        format.html { render :new }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payrolls/1
  # PATCH/PUT /payrolls/1.json
  def update
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to payrolls_path, flash: { success: 'Payroll was successfully updated.' } }
        format.json { render :show, status: :ok, location: @payroll }
      else
        format.html { render :edit }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1
  # DELETE /payrolls/1.json
  def destroy
    @payroll.destroy
    respond_to do |format|
      format.html { redirect_to payrolls_path, flash: { success: 'Payroll was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    def reports_data(payrolls)
      @timesheet_ids = Timesheet.where(payroll_id: payrolls.map(&:id)).map(&:id)
      @visits = Visit.where(timesheet_id: @timesheet_ids).includes(:reimbursements, :reimbursements_visits)
      hours = Hour.where(timesheet_id: @timesheet_ids)
      @visit_types = @visits.map(&:visit_type).uniq
      @hour_types = hours.map(&:hour_type).uniq
      @users = User.all.includes(:timesheets)
    end

    def set_payroll_configurations
      payroll = AdminConfiguration.find_by(title: 'payroll')
      @payroll_configurations =  payroll.configurations if payroll
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_params
      params.require(:payroll).permit(:start_date, :end_date, :submission_date, :admission_date)
    end
end
