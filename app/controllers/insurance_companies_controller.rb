class InsuranceCompaniesController < ApplicationController
  before_action :set_insurance_company, only: [:show, :edit, :update]
  before_action :set_insurance_companies, only: [:destroy]

  # GET /insurance_companies
  # GET /insurance_companies.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: InsuranceCompanyDatatable.new(view_context) }
    end
  end

  # GET /insurance_companies/1
  # GET /insurance_companies/1.json
  def show
  end

  # GET /insurance_companies/new
  def new
    @insurance_company = InsuranceCompany.new
  end

  # GET /insurance_companies/1/edit
  def edit
  end

  # POST /insurance_companies
  # POST /insurance_companies.json
  def create
    @insurance_company = InsuranceCompany.new(insurance_company_params)

    respond_to do |format|
      if @insurance_company.save
        format.any { redirect_to insurance_companies_path, notice: 'Insurance company was successfully created.' }
      else
        format.html { render :new }
        format.json
      end
    end
  end

  # PATCH/PUT /insurance_companies/1
  # PATCH/PUT /insurance_companies/1.json
  def update
    respond_to do |format|
      if @insurance_company.update(insurance_company_params)
        format.html { redirect_to @insurance_company, notice: 'Insurance company was successfully updated.' }
        format.json { render :show, status: :ok, location: @insurance_company }
      else
        format.html { render :edit }
        format.json
      end
    end
  end

  # DELETE /insurance_companies/1
  # DELETE /insurance_companies/1.json
  def destroy
    @insurance_companies.map(&:destroy)
    respond_to do |format|
      format.html { redirect_to insurance_companies_path, notice: 'Insurance company was successfully destroyed.' }
      format.json { render json: { data: [] } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_insurance_company
      @insurance_company = InsuranceCompany.find(params[:id])
    end

    def set_insurance_companies
      @insurance_companies = InsuranceCompany.find(params[:id].split(','))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def insurance_company_params
      params.require(:insurance_company).permit(:name, :description)
    end
end
