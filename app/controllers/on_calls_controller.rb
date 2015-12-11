class OnCallsController < ApplicationController
  before_action :set_on_call, only: [:show, :edit, :update, :destroy]

  # GET /on_calls
  # GET /on_calls.json
  def index
    if params[:line_item_ids]
      on_call_ids  = LineItem.where(id: params[:line_item_ids].split(','), payable_type: 'OnCall').map(&:payable_id)
      @on_calls = current_user.on_calls.where(id: on_call_ids)
    else
      @on_calls = [] # OnCall.all
    end
  end

  # GET /on_calls/1
  # GET /on_calls/1.json
  def show
  end

  # GET /on_calls/new
  def new
    @on_call = OnCall.new
    user = params[:user_id] || current_user
    @on_call = OnCall.new(user_id: user, timesheet_id: params[:timesheet_id], progress_state: (params[:progress_state] || 'logged'))
    @timesheet_id = params[:timesheet_id] || nil
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /on_calls/1/edit
  def edit
  end

  # POST /on_calls
  # POST /on_calls.json
  def create
    @on_call = OnCall.new(on_call_params)
    @on_call.user = current_user
    @on_call.progress_state = 'pending'

    respond_to do |format|
      if @on_call.save
        if params[:timesheet_id]
          format.html { redirect_to @on_call, notice: 'On call was successfully created.' }
          format.js {redirect_to timesheet_path(id: params[:timesheet_id])}
        else
          format.html { redirect_to @on_call, notice: 'On call was successfully created.' }
          format.json { render :show, status: :created, location: @on_call }
        end
      else
        format.html { render :new }
        format.js
        format.json 
      end
    end
  end

  # PATCH/PUT /on_calls/1
  # PATCH/PUT /on_calls/1.json
  def update
    respond_to do |format|
      if @on_call.update(on_call_params)
        format.html { redirect_to @on_call, notice: 'On call was successfully updated.' }
        format.json { render :show, status: :ok, location: @on_call }
      else
        format.html { render :edit }
        format.json { render json: @on_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /on_calls/1
  # DELETE /on_calls/1.json
  def destroy
    @on_call.destroy
    respond_to do |format|
      format.html { redirect_to on_calls_url, notice: 'On call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_on_call
      @on_call = OnCall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def on_call_params
      params.require(:on_call).permit(:date, :note, :timesheet_id, :progress_state, :user_id)
    end
end
