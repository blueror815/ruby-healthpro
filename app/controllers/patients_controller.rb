class PatientsController < ApplicationController
  # callbacks
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  before_action :set_custom_forms_collection, only: [:new, :edit, :update]
  before_action :prepare_patient_forms, only: [:edit, :show, :update]
  before_action :set_user_form_authorization, only: [:new, :edit, :update_forms]

  def index
    authorize! :view, Patient
    respond_to do |format|
      format.html
      format.json { render json: PatientDatatable.new(view_context) }
    end
  end

  def show
    authorize! :view, Patient
    @redirect_path = patient_path(@patient)
  end

  def new
    authorize! :edit, Patient
    @patient = Patient.new
    set_patient_forms
  end

  def edit
    authorize! :edit, Patient
  end

  def get_patient_data
    @patient = Patient.includes(:insurance_companies).find(params[:patient_id])
  end

  def create
    authorize! :edit, Patient
    set_patient_forms
    @patient = Patient.new(patient_params)
    respond_to do |format|
      if @patient.save
        format.html { redirect_to patients_path, flash: { success: 'patient was successfully created.' } }
        format.json { render :show, status: :created, location: @patient }
      else
        set_user_form_authorization
        set_custom_forms_collection
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patient/1
  # PATCH/PUT /patient/1.json
  def update
    authorize! :edit, Patient
    respond_to do |format|
      if @patient.update(patient_params)
        # set_form_data(params[:custom_form_ids]) if params[:custom_form_ids]
        format.html { redirect_to patient_path, flash: { success: 'patient was successfully updated.' } }
        format.json { render :show, status: :ok, location: @patient }
      else
        # set_available_custom_forms
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient/1
  # DELETE /patient/1.json
  def destroy
    authorize! :edit, Patient
    respond_to do |format|
      if @patient.destroy
        format.html { redirect_to patients_path, flash: { success: 'patient was successfully destroyed.' } }
        format.json { head :no_content }
      else
        format.html { redirect_to patients_path, flash: { success: 'patient has not been destroyed.' } }
      end
    end
  end

  def scrape_patients
    authorize! :edit, Patient
    msg = 'Scrapping patients is in progress'
    type = :success
    begin
      Patient.delay.scrape_patients
    rescue e
      msg = "Scrapping patients success#{}"
      type = :error
    end
    redirect_to patients_path, flash: { type => msg }
  end

  def delete_all_patients
    authorize! :edit, Patient
    Patient.delete_all
    redirect_to patients_path, flash: { success: 'Patients were successfully deleted.' }
  end

  def update_forms
    authorize! :edit, Patient
    if !params[:custom_form_id].blank?
      if params[:id].to_i != 0
        set_patient
        @form_datum = current_user.created_form_data.new(custom_form_id: params[:custom_form_id])
      else
        @patient = User.new
        @form_datum = current_user.created_form_data.new(custom_form_id: params[:custom_form_id])
      end
      set_patient_forms
    end
    respond_to :js
  end

  def find_patients_matches
    @patients = if params[:q].nil? || params[:q] == '' 
      []
    else
      Patient.where("display_name like ? ", "%#{params['q']}%")
    end
    respond_to do |format|
      format.json
    end
  end

  private
  def set_patient
    @patient = Patient.find(params[:id])
  end

  def set_patient_forms
    @patient_forms = FormCategory.find_by(name: 'Patient').custom_forms
  end

  def set_form_data(custom_form_ids = [])
    patient_custom_form_ids = @patient.form_data.map(&:custom_form).uniq.map(&:id)
    patient_category = FormCategory.find_by(name: 'Patient')
    patient_forms = @patient.form_data.joins(:custom_form).where('custom_forms.form_category_id = ?', patient_category.id)
    if patient_custom_form_ids.include?(custom_form_ids)
      return
    else
      if patient_forms && patient_forms.map(&:custom_form_id) != custom_form_ids
        patient_forms.select { |i| !custom_form_ids.include?(i.custom_form_id) }.map(&:destroy)
      end
      custom_form_ids -= patient_forms.map(&:custom_form_id)
      CustomForms::CustomForm.where(id: custom_form_ids).where("permissions -> ? ->> 'create' = '1'", current_user.role.short_name).each do |form|
        section_fields = {}
        form.sections.each do |k, v|
          fields = {}
          v['fields'].values.each do |field|
            fields[field['name']] = ''
          end
          section_fields[k] = fields
        end
        @patient.form_data.create(custom_form_id: form.id, sections_data: section_fields, creator_user_id: current_user.id)
      end
    end
  end

  def set_custom_forms_collection
    used_forms = @patient_forms_data || []
    patient_category = FormCategory.find_by(name: 'Patient')
    @custom_forms_collection = []
    if patient_category
      @custom_forms_collection = patient_category.custom_forms.where("permissions -> ? ->> 'create' = '1'", current_user.role.short_name) - used_forms
    end
  end

  def prepare_patient_forms
    set_patient_forms
    @patient_forms_data = @patient.form_data.includes(:custom_form).where(custom_form_id: @patient_forms)
  end

  def patient_params
    params[:custom_form_ids].reject!(&:blank?) if params[:custom_form_ids]
    section_fields = []
    @patient_forms.each do |custom_form|
      section_fields << forms_fields(custom_form, 'create')
    end
    params.require(:patient).permit(:contact_number, :display_name, :email, :agency_id,
                                    :zipcode, :city, :address, :phone, :apartment_number,
                                    :state, :emergency_contact, :emergency_contact_phone,
                                    :image, :soc_date, :discharged_date, insurance_company_ids: [],
                                    form_data_attributes: [:id, :custom_form_id, :creator_user_id, sections_data: section_fields.flatten,
                                    attachments_attributes: [:id, :file, :form_datum_field]])
  end
end
