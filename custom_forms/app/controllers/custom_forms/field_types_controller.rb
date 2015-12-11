module CustomForms
  class FieldTypesController < ApplicationController
    before_action :set_field_type, only: [:show, :edit, :update, :destroy]
    before_action :has_section_fields?, only: [:edit, :update, :destroy]
    helper_method :get_model_attributes_names
    helper_method :get_form_attributes_names
    # GET /field_types
    # GET /field_types.json
    def index
      authorize! :view, CustomForms::FieldType
      @field_types = FieldType.includes(:section_fields)
    end

    # GET /field_types/1
    # GET /field_types/1.json
    def show
      authorize! :view, CustomForms::FieldType
    end

    # GET /field_types/new
    def new
      authorize! :edit, CustomForms::FieldType
      @field_type = FieldType.new
    end

    # GET /field_types/1/edit
    def edit
      authorize! :edit, CustomForms::FieldType
    end

    # POST /field_types
    # POST /field_types.json
    def create
      authorize! :edit, CustomForms::FieldType
      @field_type = FieldType.new(field_type_params)

      respond_to do |format|
        if @field_type.save
          format.html { redirect_to field_types_url, notice: 'Field type was successfully created.' }
          format.json { render :show, status: :created, location: @field_type }
        else
          format.html { render :new }
          format.json { render json: @field_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /field_types/1
    # PATCH/PUT /field_types/1.json
    def update
      authorize! :edit, CustomForms::FieldType
      respond_to do |format|
        if @field_type.update(field_type_params)
          format.html { redirect_to field_types_url, notice: 'Field type was successfully updated.' }
          format.json { render :show, status: :ok, location: @field_type }
        else
          format.html { render :edit }
          format.json { render json: @field_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /field_types/1
    # DELETE /field_types/1.json
    def destroy
      authorize! :edit, CustomForms::FieldType
      @field_type.destroy
      respond_to do |format|
        format.html { redirect_to field_types_path, notice: 'Field type was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      def has_section_fields?
        redirect_to :back, flash: { error: 'Action not permitted' } if @field_type.section_fields.any?
      end
      # Use callbacks to share common setup or constraints between actions.
      def set_field_type
        @field_type = FieldType.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def field_type_params
        params.require(:field_type).permit(:name, :field_type, :input_mask, options: [:options, :model_name, :model_attribute, :custom_form_id, :section_field_id, :multivalue])
      end
  end
end
