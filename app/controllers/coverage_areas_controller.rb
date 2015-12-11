class CoverageAreasController < ApplicationController
  before_action :set_coverage_area, only: [:show, :edit, :update, :destroy]

  # GET /coverage_areas
  # GET /coverage_areas.json
  def index
    @coverage_areas = CoverageArea.all
    @instances = @coverage_areas 
    @model = "coverage_area"
    @icon = "fa-cogs"
  end

  # GET /coverage_areas/1
  # GET /coverage_areas/1.json
  def show
  end

  # GET /coverage_areas/new
  def new
    @coverage_area = CoverageArea.new
    set_html_elements
  end

  # GET /coverage_areas/1/edit
  def edit
    @instance = @coverage_area
    @model = "coverage_area"
  end

  # POST /coverage_areas
  # POST /coverage_areas.json
  def create
    @coverage_area = CoverageArea.new(coverage_area_params)

    respond_to do |format|
      if @coverage_area.save
        format.html { redirect_to coverage_areas_path, notice: 'Coverage area was successfully created.' }
        format.json { render :show, status: :created, location: @coverage_area }
      else
        set_html_elements
        format.html { render :new }
        format.json { render json: @coverage_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coverage_areas/1
  # PATCH/PUT /coverage_areas/1.json
  def update
    respond_to do |format|
      if @coverage_area.update(coverage_area_params)
        format.html { redirect_to coverage_areas_path, notice: 'Coverage area was successfully updated.' }
        format.json { render :show, status: :ok, location: @coverage_area }
      else
        set_html_elements
        format.html { render :edit }
        format.json { render json: @coverage_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coverage_areas/1
  # DELETE /coverage_areas/1.json
  def destroy
    @coverage_area.destroy
    respond_to do |format|
      format.html { redirect_to coverage_areas_path, notice: 'Coverage area was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_html_elements
    @instance = @coverage_area
    @model = "coverage_area"
    @id = CoverageArea.count
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_coverage_area
    @coverage_area = CoverageArea.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def coverage_area_params
    params.require(:coverage_area).permit(:name)
  end
end
