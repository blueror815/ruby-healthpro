class VisitsController < ApplicationController
  before_action :set_visit, only: [:show, :edit, :update, :destroy, :show_comments]
  skip_authorize_resource

  # GET /visits
  # GET /visits.json
  def index
    authorize! :view_all, Visit
    respond_to do |format|
      format.html
      format.json { render json: VisitDatatable.new(view_context) }
    end
  end

  # GET /visits/1
  # GET /visits/1.json
  def show
    set_reimbursements
  end

  # GET /visits/new
  def new
    authorize! :edit, Visit
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
    authorize! :edit, Visit
    @timesheet_id = params[:timesheet_id] || nil
    set_reimbursements
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /visits
  # POST /visits.json
  def create
    authorize! :edit, Visit
    @visit = Visit.new(visit_params)
    @visit.assigner = current_user
    respond_to do |format|
      if @visit.save
        format.html { redirect_to @visit, falsh: { success: 'Visit was successfully created.' } }
        format.json { render json: @visit}
      else
        format.html { render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  def update
    @visit.assigner = current_user
    respond_to do |format|
      if @visit.update(visit_params)
        format.html { redirect_to @visit, falsh: { success: 'Visit was successfully updated.' } }
        format.json { render :show, status: :ok, location: @visit }
        if params[:timesheet_id]
          format.js {redirect_to timesheet_path(id: params[:timesheet_id])}
        else
          format.js
          format.json { render json: @visit}
        end
      else
        format.html { render :edit }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.json
  def destroy
    @visit.destroy
    respond_to do |format|
      format.html { redirect_to visits_path, falsh: { success: 'Visit was successfully destroyed.' } }
      format.json { render json: {"data" => []}}
    end
  end

  def show_comments
    respond_to do |format|
      format.js
    end
  end

  def view_assigned_visits
     @events_array = []
     @today_visits = []
     @visits = Visit.user_visits(current_user.id)
     @visits.each do |visit|
       @events_array << { title: "#{visit.visit_type.title} ##{visit.id}",
                          start: visit.time_in.strftime('%Y, %m, %d'),
                          end: visit.time_out.strftime('%Y, %m, %d')}
       @today_visits << visit if visit.date && visit.date.today?
     end

  end

  def scrape_visits
    authorize! :edit, Visit
    msg = 'Scrapping visits is in progress'
    type = :success
    begin
      Visit.delay.scrape_visits
    rescue e
      msg = "Scrapping visits success#{}"
      type = :error
    end
    redirect_to visits_path, flash: { type => msg }
  end

  private

  def set_reimbursements
    not_included_reimbursements = @visit.visit_type.reimbursements - @visit.reimbursements
    @new_reimbursements_visits = []
    not_included_reimbursements.each do |reimbursement|
      @new_reimbursements_visits << reimbursement.reimbursements_visits.new
      @new_reimbursements_visits.last.visit = @visit
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_visit
    @visit = Visit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visit_params
    params.require(:visit).permit(
      :notification,
      :medical_record_number, 
      :progress_state, 
      :billing_state, 
      :billing_code, 
      :date, 
      :assigned_time, 
      :occurred_time, 
      :agency_id, 
      :assigner_id, 
      :assignee_id, 
      :patient_id, 
      :visit_type_id, 
      :time_in,
      :time_out,
      reimbursements_visits_attributes: [:reimbursement_id, :id, :action_count, :comment, :_destroy]
      )
  end
end
