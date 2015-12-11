module CustomForms
  class FormDataController < ApplicationController
    before_action :set_custom_form
    before_action :set_form_datum, only: [:show, :edit, :update, :destroy]
    before_action :set_user_forms, only: [:new, :edit, :create, :update, :destroy]
    before_action :check_user_form_authorization, only: [:new, :edit, :create, :update, :destroy]
    before_action :set_redirect_path, only: [:edit]

    # GET /form_data
    # GET /form_data.json
    def index
    end

    # GET /form_data/1
    # GET /form_data/1.json
    def show
      @custom_form = @form_datum.custom_form
    end

    # GET /form_data/new
    def new
      @form_datum = FormDatum.new(sections_data: { '0'=> {} })
      @form_datum.attachments.build
    end

    # GET /form_data/1/edit
    def edit
      @custome_form = @form_datum.custom_form
    end

    # POST /form_data
    # POST /form_data.json
    def create
      @form_datum = CustomForms::FormDatum.new(form_datum_params)
      @user = User.find(params[:form_datum][:user_id]) if params[:form_datum][:user_id]
      @form_datum.user = @user
      @form_datum.creator = current_user
      @form_datum.custom_form = @custom_form
      # remove_empty_elements_from_array
      respond_to do |format|
        if @form_datum.save
          format.html { redirect_to custom_forms.form_path(@custom_form.id), flash: { success: 'Form datum was successfully created.' } }
          format.json { render :show, status: :created, location: @form_datum }
        else
          format.html { render :new }
          format.json { render json: @form_datum.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /form_data/1
    # PATCH/PUT /form_data/1.json
    def update
      respond_to do |format|
        # remove empty string need to be refactor

        if @form_datum.update(form_datum_params)
          # remove_empty_elements_from_array
          # @form_datum.save
          path = params[:redirect_path].present? ? params[:redirect_path] : session[:redirect_path]
          if path
            session[:redirect_path] = nil
            format.html { redirect_to path, flash: { success: 'Form datum was successfully updated.' } }
          else
            format.html { redirect_to custom_forms.form_path(@custom_form), flash: { success: 'Form datum was successfully updated.' } }
            format.json { render :show, status: :created, location: @form_datum }
          end
        else
          format.html { render :new }
          format.json { render json: @form_datum.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /form_data/1
    # DELETE /form_data/1.json
    def destroy
      @form_datum.destroy
      respond_to do |format|
        format.html { redirect_to form_data_path, flash: { success: 'Form datum was successfully destroyed.' } }
        format.json { head :no_content }
        format.js
      end
    end

    private
      def remove_empty_elements_from_array
        @form_datum.sections_data.each do |section_num, section|
          section.each do |field_name, field_value|
            if field_value.is_a? Array
              @form_datum.sections_data[section_num][field_name] = @form_datum.sections_data[section_num][field_name].reject!(&:empty?)
            end
          end
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_redirect_path
        @redirect_path = params[:redirect_path]
      end

      def set_user_forms
        role = current_user.role.short_name
        @forms_to_create = CustomForms::CustomForm.where("permissions -> ? ->> 'create' = '1'", role)
        @forms_to_edit = CustomForms::CustomForm.where("permissions -> ? ->> 'edit' = '1'", role)
        @forms_to_show = CustomForms::CustomForm.where("permissions -> ? ->> 'view' = '1'", role)
      end

      def set_custom_form
        @custom_form = CustomForms::CustomForm.includes(form_sections: :field_types).find(params[:custom_form_id])
      end

      def set_form_datum
        @form_datum = @custom_form.form_data.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def form_datum_params
        section_fields = forms_fields(@custom_form, @action)
        params.require(:form_datum).permit(:custom_form_id, :user_id, sections_data: section_fields.flatten, attachments_attributes: [:id, :file, :section_field_id])
      end
  end
end
