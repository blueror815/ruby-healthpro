class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy]

  # GET /agencies
  # GET /agencies.json
  def index
    @agencies = Agency.all
    @instances = @agencies
    @model = 'agency'
    @icon = 'fa-cogs'
  end

  # GET /agencies/1
  # GET /agencies/1.json
  def show
  end

  # GET /agencies/new
  def new
    @agency = Agency.new
    set_html_elements
  end

  # GET /agencies/1/edit
  def edit
    @instance = @agency
    @model = 'agency'
  end

  # POST /agencies
  # POST /agencies.json
  def create
    @agency = Agency.new(agency_params)

    respond_to do |format|
      if @agency.save
        format.html { redirect_to agencies_path, flash: { success: 'Agency was successfully created.' } }
        format.json { render :show, status: :created, location: @agency }
      else
        set_html_elements
        format.html { render :new }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agencies/1
  # PATCH/PUT /agencies/1.json
  def update
    respond_to do |format|
      if @agency.update(agency_params)
        format.html { redirect_to agencies_path, flash: { success: 'Agency was successfully updated.' } }
        format.json { render :show, status: :ok, location: @agency }
      else
        format.html { render :edit }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.json
  def destroy
    @agency.destroy
    respond_to do |format|
      format.html { redirect_to agencies_path, flash: { success: 'Agency was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  def scrape_agencies
    msg = 'Scrapping agencies is in progress'
    type = :success
    begin
      Agency.delay.scrape_agency
    rescue e
      msg = "Scrapping agencies success#{}"
      type = :error
    end

    redirect_to agencies_path, flash: { type => msg }
  end

  private
  def set_html_elements
    @instance = @agency
    @model = 'agency'
    @id = Agency.count
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_agency
    @agency = Agency.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def agency_params
    params.require(:agency).permit(:phone, :fax, :zipcode, :state, :city, :devero_id, :display_name, :short_name, :address, :address2, :email, :name, :medicare_provider_number, :hha_agency_id, :rate, :fax_service_username, :fax_service_account_id, :timezone)
  end
end
