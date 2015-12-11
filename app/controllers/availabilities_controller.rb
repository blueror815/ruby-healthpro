class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :edit, :update]
  before_action :set_availabilities, only: [:destroy]

  # GET /availabilities
  # GET /availabilities.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: AvailabilityDatatable.new(view_context) }
    end
  end

  # GET /availabilities/1
  # GET /availabilities/1.json
  def show
  end

  # GET /availabilities/new
  def new
    @availability = Availability.new
  end

  # GET /availabilities/1/edit
  def edit
  end

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = Availability.new(availability_params)

    respond_to do |format|
      if @availability.save
        format.html { redirect_to @availability, notice: 'Availability was successfully created.' }
        format.json { render :show, status: :created, location: @availability }
      else
        format.html { render :new }
        format.json
      end
    end
  end

  # PATCH/PUT /availabilities/1
  # PATCH/PUT /availabilities/1.json
  def update
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to @availability, notice: 'Availability was successfully updated.' }
        format.json { render :show, status: :ok, location: @availability }
      else
        format.html { render :edit }
        format.json
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availabilities.map(&:destroy)
    respond_to do |format|
      format.html { redirect_to availabilities_url, notice: 'Availability was successfully destroyed.' }
      format.json { render json: { data: [] } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_availability
      @availability = Availability.find(params[:id])
    end

    def set_availabilities
      @availabilities = Availability.find(params[:id].split(','))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def availability_params
      params.require(:availability).permit(:name, :description)
    end
end
