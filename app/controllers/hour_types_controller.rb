class HourTypesController < ApplicationController
  before_action :set_hour_type, only: [:show, :edit, :update, :destroy]

  # GET /hour_types
  # GET /hour_types.json
  def index
    @hour_types = HourType.all
    @instances = @hour_types
    @model = "hour_type"
    @icon = "fa-cogs"
  end

  # GET /hour_types/1
  # GET /hour_types/1.json
  def show
  end

  # GET /hour_types/new
  def new
    @hour_type = HourType.new
    set_html_elements
  end

  # GET /hour_types/1/edit
  def edit
  end

  # POST /hour_types
  # POST /hour_types.json
  def create
    @hour_type = HourType.new(hour_type_params)

    respond_to do |format|
      if @hour_type.save
        format.html { redirect_to hour_types_path, notice: 'Hour type was successfully created.' }
        format.json { render :show, status: :created, location: @hour_type }
      else
        set_html_elements
        format.html { render :new }
        format.json { render json: @hour_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hour_types/1
  # PATCH/PUT /hour_types/1.json
  def update
    respond_to do |format|
      if @hour_type.update(hour_type_params)
        format.html { redirect_to hour_types_path, notice: 'Hour type was successfully updated.' }
        format.json { render :show, status: :ok, location: @hour_type }
      else
        format.html { render :edit }
        format.json { render json: @hour_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hour_types/1
  # DELETE /hour_types/1.json
  def destroy
    @hour_type.destroy
    respond_to do |format|
      format.html { redirect_to hour_types_url, notice: 'Hour type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_html_elements
      @instance = @hour_type
      @model = "hour_type"
      # TODO_PROHEALTH this needs to be refactors can't use count 
      @id = HourType.count
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_hour_type
      @hour_type = HourType.find(params[:id])
      @instance = @hour_type
      @model = "hour_type"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hour_type_params
      params.require(:hour_type).permit(:title, :price_factor, department_ids: [], job_type_ids: [])
    end
end
