class BonusesController < ApplicationController
  before_action :set_bonuse, only: [:show, :edit, :update, :destroy]

  # GET /bonuses
  # GET /bonuses.json
  def index
    @bonuses = Bonuse.all
  end

  # GET /bonuses/1
  # GET /bonuses/1.json
  def show
  end

  # GET /bonuses/new
  def new
    @bonuse = Bonuse.new
    user = User.find(params[:user_id])
    @bonuse = Bonuse.new(user_id: user.id, timesheet_id: params[:timesheet_id])
    @timesheet_id = params[:timesheet_id] || nil
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /bonuses/1/edit
  def edit
  end

  # POST /bonuses
  # POST /bonuses.json
  def create
    @bonuse = Bonuse.new(bonuse_params)
    respond_to do |format|
      if @bonuse.save
        if params[:timesheet_id]
          format.html { redirect_to @bonuse, notice: 'Bonuse was successfully created.' }
          format.json { render :show, status: :created, location: @bonuse }
          format.js {redirect_to timesheet_path(id: params[:timesheet_id], user_id: @bonuse.user.id)}
        end
      else
        format.html { render :new }
        format.json { render json: @bonuse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bonuses/1
  # PATCH/PUT /bonuses/1.json
  def update
    respond_to do |format|
      if @bonuse.update(bonuse_params)
        format.html { redirect_to @bonuse, notice: 'Bonuse was successfully updated.' }
        format.json { render :show, status: :ok, location: @bonuse }
      else
        format.html { render :edit }
        format.json { render json: @bonuse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bonuses/1
  # DELETE /bonuses/1.json
  def destroy
    @bonuse.destroy
    respond_to do |format|
      format.html { redirect_to bonuses_url, notice: 'Bonuse was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bonuse
      @bonuse = Bonuse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bonuse_params
      params.require(:bonuse).permit(:user_id, :price, :timesheet_id)
    end
end
