class ReimbursementTimesheetsController < ApplicationController
  before_action :set_reimbursement_timesheet, only: [:show, :edit, :update, :destroy]

  # GET /reimbursement_timesheets
  # GET /reimbursement_timesheets.json
  def index
    @reimbursement_timesheets = ReimbursementTimesheet.all
  end

  # GET /reimbursement_timesheets/1
  # GET /reimbursement_timesheets/1.json
  def show
  end

  # GET /reimbursement_timesheets/new
  def new
    @reimbursement_timesheet = ReimbursementTimesheet.new
    user = params[:user_id] || current_user
    @reimbursement_timesheet = ReimbursementTimesheet.new(user_id: user, timesheet_id: params[:timesheet_id], progress_state: (params[:progress_state] || 'logged'))
    @timesheet_id = params[:timesheet_id] || nil
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /reimbursement_timesheets/1/edit
  def edit
  end

  # POST /reimbursement_timesheets
  # POST /reimbursement_timesheets.json
  def create
    @reimbursement_timesheet = ReimbursementTimesheet.new(reimbursement_timesheet_params)
    @reimbursement_timesheet.user = current_user
    @reimbursement_timesheet.progress_state = 'pending'

    respond_to do |format|
      if @reimbursement_timesheet.save
        if params[:timesheet_id]
          format.json { render :show, status: :created, location: @reimbursement_timesheet }
          format.js {redirect_to timesheet_path(id: params[:timesheet_id])}
        else
          format.html { redirect_to @reimbursement_timesheet, notice: 'Reimbursement timesheet was successfully created.' }
          format.json { render :show, status: :created, location: @reimbursement_timesheet }
        end
      else
        format.html { render :new }
        format.js
        format.json { render json: @reimbursement_timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reimbursement_timesheets/1
  # PATCH/PUT /reimbursement_timesheets/1.json
  def update
    respond_to do |format|
      if @reimbursement_timesheet.update(reimbursement_timesheet_params)
        format.html { redirect_to @reimbursement_timesheet, notice: 'Reimbursement timesheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @reimbursement_timesheet }
      else
        format.html { render :edit }
        format.json { render json: @reimbursement_timesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reimbursement_timesheets/1
  # DELETE /reimbursement_timesheets/1.json
  def destroy
    @reimbursement_timesheet.destroy
    respond_to do |format|
      format.html { redirect_to reimbursement_timesheets_url, notice: 'Reimbursement timesheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reimbursement_timesheet
      @reimbursement_timesheet = ReimbursementTimesheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reimbursement_timesheet_params
      params.require(:reimbursement_timesheet).permit(:reimbursement_id, :user_id,
                                                      :timesheet_id, :progress_state,
                                                      :action_count, :note, :amount)
    end
end
