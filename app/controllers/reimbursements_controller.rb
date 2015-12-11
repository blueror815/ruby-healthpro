class ReimbursementsController < ApplicationController
  before_action :set_reimbursement, only: [:show, :edit, :update, :destroy]
  before_action :set_reimbursements, only: [:destroy]

  # GET /reimbursements
  # GET /reimbursements.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: ReimbursementDatatable.new(view_context) }
    end
  end

  # GET /reimbursements/1
  # GET /reimbursements/1.json
  def show
    respond_to :js
  end

  # GET /reimbursements/new
  def new
    @reimbursement = Reimbursement.new
    set_html_elements
  end

  # GET /reimbursements/1/edit
  def edit
  end

  # POST /reimbursements
  # POST /reimbursements.json
  def create
    @reimbursement = Reimbursement.new(reimbursement_params)

    respond_to do |format|
      if @reimbursement.save
        format.html { redirect_to reimbursements_path, flash: { success: 'Reimbursement was successfully created.' } }
        format.json { render :show, status: :created, location: @reimbursement }
      else
        set_html_elements
        format.html { render :new }
        format.json
      end
    end
  end

  # PATCH/PUT /reimbursements/1
  # PATCH/PUT /reimbursements/1.json
  def update
    respond_to do |format|
      if @reimbursement.update(reimbursement_params)
        format.html { redirect_to reimbursements_path, flash: { success: 'Reimbursement was successfully updated.' } }
        format.json { render :show, status: :ok, location: @reimbursement }
      else
        set_html_elements
        format.html { render :edit }
        format.json { render json: @reimbursement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reimbursements/1
  # DELETE /reimbursements/1.json
  def destroy
    @reimbursement.destroy
    respond_to do |format|
      format.html { redirect_to reimbursements_url, flash: { success: 'Reimbursement was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    def set_html_elements
      @instance = @reimbursement
      @id = Role.count
      @model = "reimbursement"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_reimbursement
      @reimbursement = Reimbursement.find(params[:id])
      @model = "reimbursement"
      @instance = @reimbursement
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reimbursement_params
      # params[:reimbursement] = params[:data].values.first
      params.require(:reimbursement).permit(:title, :value_type, :price, :include_in_timesheet)
    end

    def set_reimbursements
      @reimbursements = Reimbursements.find(params[:id].split(','))
    end
end
