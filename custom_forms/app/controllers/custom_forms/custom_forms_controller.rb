module CustomForms
  class CustomFormsController < ApplicationController
    before_action :set_roles_and_permissions, only: [:edit, :new, :update, :create]
    before_action :set_custom_form, only: [:show, :edit, :update, :destroy]
    # GET /custom_forms
    # GET /custom_forms.json
    def index
      @custom_forms = CustomForm.all
    end

    # GET /custom_forms/1
    # GET /custom_forms/1.json
    def show
    end

    # GET /custom_forms/new
    # TODO: move to after _init
    # TODO: add comments
    def new
      @redirect_path = params[:redirect_path] || ''
      permissions = {}
      @user_roles.each do |user_role|
        permissions[user_role] = {}
        @user_abilities.each do |user_ability|
          permissions[user_role][user_ability] = 1
        end
      end

      @custom_form = CustomForms::CustomForm.new(
        form_category_id: params[:form_category],
        permissions: permissions,
      )
      @custom_form.form_sections.build(permissions: permissions)
    end

    # GET /custom_forms/1/edit
    def edit
    end

    # POST /custom_forms
    # POST /custom_forms.json
    def create
      path = params[:redirect_path].present? ? params[:redirect_path] : custom_forms_path
      @custom_form = CustomForm.new(custom_form_params)
      path = params[:redirect_path].present? ? params[:redirect_path] : custom_forms_path
      respond_to do |format|
        if @custom_form.save
          format.html { redirect_to path, flash: { success: 'Custom form was successfully created.' } }
          format.json { render :show, status: :created, location: @custom_form }
        else
          format.html { render :new }
          format.json { render json: @custom_form.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /custom_forms/1
    # PATCH/PUT /custom_forms/1.json
    def update
      # params['custom_form']['sections'] = {} if params['custom_form']['sections'].nil?
      path = params[:redirect_path].present? ? params[:redirect_path] : custom_forms_path
      deleted_fields = get_deleted_fields
      respond_to do |format|
        begin
          updated = true if @custom_form.update(custom_form_params)
        rescue ActiveRecord::RecordNotDestroyed => e
          @custom_form.errors.add(:section_fields, "should not be less than one")
        end

        if updated
          unless deleted_fields.empty?
            @custom_form.remove_deleted_fields_from_instances(deleted_fields)
          end
          format.html { redirect_to path, flash: { success: 'Custom form was successfully updated.' } }
          format.json { render :show, status: :ok, location: @custom_form }
        else
          format.html { render :edit, flash: { error: "Fields should not be less than one" } }
          format.json { render json: @custom_form.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /custom_forms/1
    # DELETE /custom_forms/1.json
    def destroy
      begin
        destroyed = true if @custom_form.destroy
      rescue ActiveRecord::RecordNotDestroyed => e
      end

      if destroyed
        respond_to do |format|
          format.html { redirect_to :back, flash: { success: 'Custom form was successfully destroyed.' } }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back, flash: { error: "Custom form has form data" } }
          format.json { head :no_content }
        end
      end
    end

    def get_model_attributes
      @attributes_names = get_model_attributes_names(params['model_name'])
    end

    def get_form_attributes
      @attributes_names = get_form_attributes_names(params['form_id'])
    end

    private

    # Return fields that need to be removed from schema 
    def get_deleted_fields
      deleted_ids = {}
      if custom_form_params[:form_sections_attributes]
        custom_form_params[:form_sections_attributes].each do |section_id, section|
          if section[:section_fields_attributes]
            section[:section_fields_attributes].each  do |field_id, field| 
              deleted_ids[section_id] = (field_id.to_i + 1 ).to_s if field["_destroy"] == true
            end
          end
        end
      end
      deleted_ids
    end

    # Use callbacks to share common setup or constraints between actions.
    helper_method :get_model_attributes_names
    helper_method :get_form_attributes_names

    def set_custom_form
      @custom_form = CustomForm.find(params[:id])
    end

    def set_roles_and_permissions
      @user_roles = Role.user_roles
      @user_abilities = User.user_abilities
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_form_params
      permission_hash = {}

      @user_roles.each do |r|
        permission_hash[r.to_sym] = @user_abilities.map(&:to_sym)
      end
      params.require(:custom_form).permit(:title, :allow_comments,
                                          :form_category_id, permissions: permission_hash,
                                          form_sections_attributes: [:_destroy, :id, :title, :custom_form_id, permissions: permission_hash,
                                          section_fields_attributes: [:id, :field_type_id, :form_section_id, :index_display,
                                          :field_alias, :required, :row_order, :_destroy]])
    end
  end
end
