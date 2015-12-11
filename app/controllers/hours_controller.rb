class HoursController < ApplicationController
  before_action :set_hour, only: [:show, :edit, :update, :destroy]

  # GET /hours
  # GET /hours.json
  def index
    authorize! :view_all, Visit
    @hours = Hour.all
  end

  # GET /hours/1
  # GET /hours/1.json
  def show
  end

  # GET /hours/new
  def new
    user = params[:user_id] || current_user
    @hour = Hour.new(assignee_id: user, timesheet_id: params[:timesheet_id], progress_state: (params[:progress_state] || 'logged'))
    @timesheet_id = params[:timesheet_id] || nil
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /hours/1/edit
  def edit
    # authorize! :edit, Visit
    @timesheet_id = params[:timesheet_id] || nil
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /hours
  # POST /hours.json
  def create

    @hour = Hour.new(hour_params)
    @hour.progress_state = "logged" unless @hour.progress_state
    respond_to do |format|
      if @hour.save
        format.html { redirect_to @hour, notice: 'Hour was successfully created.' }
        format.json { render :show, status: :created, location: @hour }
        if params[:timesheet_id]
          format.js {redirect_to timesheet_path(id: params[:timesheet_id])}
        else
          format.js
          format.json { render json: @hour}
        end
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /hours/1
  # PATCH/PUT /hours/1.json
  def update
    authorize! :edit, Visit
    respond_to do |format|
      if @hour.update(hour_params)
        format.html { redirect_to @hour, notice: 'Hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @hour }
        if params[:timesheet_id]
          format.js {redirect_to timesheet_path(id: params[:timesheet_id])}
        else
          format.js
          format.json { render json: @hour}
        end
      else
        format.html { render :edit }
        format.json { render json: @hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hours/1
  # DELETE /hours/1.json
  def destroy
    @hour.destroy
    respond_to do |format|
      format.html { redirect_to hours_url, notice: 'Hour was successfully destroyed.' }
      format.json { render json: {"data" => []}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hour
      @hour = Hour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hour_params
      params.require(:hour).permit(:progress_state, :from, :to,
                                   :hour_type_id, :date, :assignee_id,
                                   :timesheet_id, comments_attributes: [:content, :user_id])
    end
end
