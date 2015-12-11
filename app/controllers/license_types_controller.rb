class LicenseTypesController < ApplicationController
  before_action :set_license_type, only: [:show, :edit, :update, :destroy]

  # GET /license_types
  # GET /license_types.json
  def index
    @license_types = LicenseType.all
  end

  # GET /license_types/1
  # GET /license_types/1.json
  def show
  end

  # GET /license_types/new
  def new
    @job_type = JobType.find params[:job_type_id]
    @license_type = @job_type.license_types.new
  end

  # GET /license_types/1/edit
  def edit
  end

  # POST /license_types
  # POST /license_types.json
  def create
    @license_type = LicenseType.new(license_type_params)

    respond_to do |format|
      if @license_type.save
        format.html { redirect_to @license_type, flash: { success: 'License type was successfully created.' } }
        format.json { render :show, status: :created, location: @license_type }
      else
        format.html { render :new }
        format.json { render json: @license_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /license_types/1
  # PATCH/PUT /license_types/1.json
  def update
    respond_to do |format|
      if @license_type.update(license_type_params)
        format.html { redirect_to @license_type, flash: { success: 'License type was successfully updated.' } }
        format.json { render :show, status: :ok, location: @license_type }
      else
        format.html { render :edit }
        format.json { render json: @license_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /license_types/1
  # DELETE /license_types/1.json
  def destroy
    @license_type.destroy
    respond_to do |format|
      format.html { redirect_to license_types_url, flash: { success: 'License type was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private

  def is_admin?
    redirect_to root_path unless current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_license_type
    @license_type = LicenseType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def license_type_params
    params.require(:license_type).permit(:name, :code, :job_type_id)
  end
end
