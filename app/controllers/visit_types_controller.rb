class VisitTypesController < ApplicationController
  # before actions
  before_action :set_visit_type, only: [:show, :edit, :update, :destroy, :get_visit_type_dependant_data, :get_visit_type_department_user]

  def new
    @visit_type = VisitType.new
    set_html_elements
    # TODO_PROHEALTH this needs to be refactors can't use count 
    @id = VisitType.count
  end

  def create
    @visit_type = VisitType.new(visit_type_params)
    respond_to do |format|
      if @visit_type.save
        format.html { redirect_to visit_types_path, flash: { success: 'Visit Type was successfully created.' } }
        format.json { render :show, status: :created, location: @visit_type }
      else
        set_html_elements
        format.html { render :new }
        format.json { render json: @visit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @visit_type.update(visit_type_params)
        format.html { redirect_to visit_types_path, flash: { success: 'Visit Type was successfully updated.' } }
        format.json { render :show, status: :ok, location: @visit_type }
      else
        format.html { render :edit }
        format.json { render json: @visit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @visit_types = VisitType.all
    @instances = @visit_types
    @model = "visit_type"
    @icon = "fa-cogs"
  end

  def show
  end

  # DELETE /visit_type/1
  # DELETE /visit_type/1.json
  def destroy
    @visit_type.destroy
    respond_to do |format|
      format.html { redirect_to visit_types_url, flash: { success: 'Visit Type was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  def get_visit_type_dependant_data
    @users = @visit_type.departments.map(&:users).flatten
    @reimbursements = @visit_type.reimbursements
  end

  private
  def set_html_elements
    @instance = @visit_type
    @model = "visit_type"
  end

  def set_visit_type
    @visit_type = VisitType.find(params[:id])
    @instance = @visit_type
    @model = "visit_type"
  end

  def visit_type_params
    params.require(:visit_type).permit(:title, :price, department_ids: [], job_type_ids: [], reimbursement_ids: [])
  end
end
