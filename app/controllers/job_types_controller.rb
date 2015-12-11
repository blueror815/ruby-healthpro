class JobTypesController < ApplicationController
  before_action :set_job_type, only: [:show, :edit, :update, :destroy]
  before_action :set_available_custom_forms, only: [:new, :edit]

  # GET /job_types
  # GET /job_types.json
  def index
    @job_types = JobType.includes(:users).order(:id)
    @instances = @job_types
    @model = 'job_type'
    @icon = 'fa-cogs'
  end

  # GET /job_types/1
  # GET /job_types/1.json
  def show
    respond_to do |format|
      format.js { @user = User.find_by(id: params[:user_id]) || User.new }
    end
  end

  # GET /job_types/new
  def new
    @job_type = JobType.new()
    set_view_variables
    @id = JobType.count
  end

  # GET /job_types/1/edit
  def edit
    set_view_variables
  end

  # POST /job_types
  # POST /job_types.json
  def create
    @job_type = JobType.new(job_type_params)

    respond_to do |format|
      if @job_type.save
        format.html { redirect_to job_types_path, flash: { success: 'Job type was successfully created.' } }
        format.json { render :show, status: :created, location: @job_type }
      else
        set_available_custom_forms
        set_view_variables
        format.html { render :new }
        format.json { render json: @job_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_types/1
  # PATCH/PUT /job_types/1.json
  def update
    respond_to do |format|
      if @job_type.update(job_type_params)
        format.html { redirect_to job_types_path, flash: { success: 'Job type was successfully updated.' } }
        format.json { render :show, status: :ok, location: @job_type }
      else
        set_available_custom_forms
        set_view_variables
        format.html { render :edit }
        format.json { render json: @job_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_types/1
  # DELETE /job_types/1.json
  def destroy
    respond_to do |format|
      if @job_type.destroy
        format.html { redirect_to job_types_path, flash: { success: 'Job type was successfully destroyed.' } }
        format.json { head :no_content }
      else
        format.html { redirect_to job_types_path, flash: { error: @job_type.errors.full_messages.to_sentence } }
      end
    end
  end

  private
  def set_available_custom_forms
    @available_custom_forms = FormCategory.find_by(name: 'HR').custom_forms.map { |a| [a.title, a.id] }
  end

  def is_admin?
    redirect_to root_path unless current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_job_type
    @job_type = JobType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_type_params
    params[:job_type][:payment_method_ids].reject!(&:blank?)
    params.require(:job_type).permit(:title, :job_class, :salary_amount, :hour_price,
                                     :on_call_price, custom_form_ids: [], payment_method_ids: [])
  end

  def set_view_variables
    @instance = @job_type
    @model = 'job_type'
  end
end
