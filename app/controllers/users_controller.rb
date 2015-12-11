class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :deactivate_user, :activate_user]
  before_action :prepare_user_forms, only: [:edit, :show, :update]
  before_action :set_custom_forms_collection, only: [:new, :edit, :update]
  before_action :set_user_form_authorization, only: [:new, :edit, :update_forms, :create]

  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def show
    @redirect_path = main_app.user_path(@user)
  end

  def new
    authorize! :edit, User
    @user = User.new
    prepare_user_forms
  end

  def create
    authorize! :edit, User
    set_hr_forms
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        # set_form_data(params[:custom_form_ids]) if params[:custom_form_ids]
        format.html { redirect_to @user, flash: { success: 'User was successfully created.' } }
        format.json { render :show, status: :created, location: @user }
      else
        prepare_user_forms
        set_custom_forms_collection
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :edit, User
    @custom_forms_collection = FormCategory.find_by(name: 'HR').custom_forms.where("permissions -> ? ->> 'create' = '1'", current_user.role.short_name)
  end

  def update_forms
    authorize! :edit, User
    if !params[:custom_form_id].blank?
      if params[:id].to_i != 0
        set_user
        @form_datum = current_user.created_form_data.new(custom_form_id: params[:custom_form_id])
      else
        @user = User.new
        @form_datum = current_user.created_form_data.new(custom_form_id: params[:custom_form_id])
      end
      set_hr_forms
    end
    respond_to :js
  end

  def update
    authorize! :edit, User
    @user.assign_attributes(user_params)
    if @user.valid? && @user.update_instance(user_params[:payment_rates_attributes].values)
      redirect_to @user, flash: { success: 'User was successfully updated.' }
    else
      @user_hr_forms_data = @user.form_data.select { |f| f.custom_form.form_category_id == @hr_forms.first.form_category_id }
      set_user_form_authorization
      render :edit
    end
  end

  def scrape_users
    authorize! :edit, User
    msg = 'Scrapping users is in progress'
    type = :success
    begin
      User.delay.scrape_users
    rescue e
      msg = "Scrapping users success#{}"
      type = :error
    end
    redirect_to users_path, flash: { type => msg }
  end

  def deactivate_user
    authorize! :edit, User
    @user.update_attribute(:inactive, true)
    redirect_to user_path(@user.id)
  end

  def activate_user
    authorize! :edit, User
    @user.update_attribute(:inactive, false)
    redirect_to user_path(@user.id)
  end

  def update_password
    @user = User.find(current_user.id)
    @user.validate_change_password = true
    respond_to do |format| 
      if @user.update_with_password(user_params)
        # Sign in the user by passing validation in case their password changed
        sign_in @user, :bypass => true
        format.js {flash[:success] = 'Password was successfully updated.'
          render 'update_password'} 
      else
        format.js {render 'update_password', locals: {user: @user}} 
      end
    end
  end


  def reset_password_via_email
    user = User.find(params[:user_id])
    user.delay.send_reset_password_instructions
    flash[:notice] = "Reset password instructions have been sent to #{user.email}."
    redirect_to user_path(user)
  end


  private
  # initializes new forms and keeps old form data as is
  def set_form_data(custom_form_ids = [])
    custom_form_ids = custom_form_ids.map(&:to_i)
    user_custom_form_ids = @user.form_data.map(&:custom_form).uniq.map(&:id)
    hr_category = FormCategory.find_by(name: 'HR')
    user_hr_forms = @user.form_data.joins(:custom_form).where('custom_forms.form_category_id = ?', hr_category.id)

    # if user_custom_form_ids.include?(custom_form_ids)
    if custom_form_ids == user_custom_form_ids
      return
    else
      if user_hr_forms && user_hr_forms.map(&:custom_form_id) != custom_form_ids
        user_hr_forms.select { |i| !custom_form_ids.include?(i.custom_form_id) }.map(&:destroy)
      end
      custom_form_ids -= user_hr_forms.map(&:custom_form_id)
      CustomForms::CustomForm.where(id: custom_form_ids).where("permissions -> ? ->> 'create' = '1'", current_user.role.short_name).each do |form|
        section_fields = {}
        form.sections.each do |k, v|
          fields = {}
          v['fields'].values.each do |field|
            fields[field['name']] = '-'
          end
          section_fields[k] = fields
        end
        current_user.created_form_data.create(user_id: @user.id, custom_form_id: form.id, sections_data: section_fields)
      end
    end
  end

  def destroy_user_hr_forms
    hr_category = FormCategory.find_by(name: 'HR')
    user_hr_forms = @user.form_data.joins(:custom_form).where('custom_forms.form_category_id = ?', hr_category.id)
    @user.form_data.destroy(user_hr_forms)
  end

  def set_custom_forms_collection
    used_forms = @user_hr_forms_data || []
    hr_category = FormCategory.find_by(name: 'HR')
    @custom_forms_collection = []
    if hr_category
      @custom_forms_collection = hr_category.custom_forms.where("permissions -> ? ->> 'create' = '1'", current_user.role.short_name) - used_forms
    end
  end

  # set user's hr form data & rest of user's form data
  def prepare_user_forms
    set_hr_forms
    @user_hr_forms_data = if @user.persisted?
                            @user.form_data.includes(:custom_form).
                            where(custom_form_id: @hr_forms.map(&:id))
                          else
                            @hr_forms.map(&:form_data).
                            map{|i| i.new(creator_user_id: current_user.id)}
                          end
  end

  def set_hr_forms
    @hr_forms = FormCategory.find_by(name: 'HR').custom_forms
  end

  def set_user
    @user = User.includes(:departments, job_type: :payment_rates, form_data: [custom_form: [form_sections: [section_fields: :field_type]]]).find(params[:id])
  end

  def user_params
    params[:custom_form_ids].reject!(&:blank?) if params[:custom_form_ids]
    password_params = [:password, :password_confirmation] if (!params[:user][:password].blank? && action_name == 'update') || ['create', 'update_password'].include?(action_name) 
    section_fields = []
    if @hr_forms
      @hr_forms.each do |custom_form|
        section_fields << forms_fields(custom_form, 'create')
      end
    end
    params[:user][:payment_rates_attributes] ||= {}
    params.require(:user).permit(password_params, :current_password, :image, :email, :display_name, :role_id, :username,
                          :job_type_id, department_ids: [], agency_ids: [], coverage_area_ids: [], availability_ids: [], 
                          payment_rates_attributes: [:id, :price, :payment_method_id, :user_id, :visit_type_id, :hour_type_id, :reimbursement_id],
                          form_data_attributes: [:_destroy, :id, :custom_form_id, :row_order, :creator_user_id, sections_data: section_fields.flatten,
                          attachments_attributes: [:id, :file, :form_datum_id, :section_field_id, :expiration_date]])
  end
end
