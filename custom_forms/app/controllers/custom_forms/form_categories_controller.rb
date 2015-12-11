module CustomForms
  class FormCategoriesController < ApplicationController
    before_action :set_form_category, only: [:show, :edit, :update, :destroy]

    # GET /form_categories
    # GET /form_categories.json
    def index
      @form_categories = FormCategory.all
    end

    # GET /form_categories/1
    # GET /form_categories/1.json
    def show
    end

    # GET /form_categories/new
    def new
      @form_category = FormCategory.new
    end

    # GET /form_categories/1/edit
    def edit
    end

    # POST /form_categories
    # POST /form_categories.json
    def create
      @form_category = FormCategory.new(form_category_params)

      respond_to do |format|
        if @form_category.save
          format.html { redirect_to form_categories_path, flash: { success: 'Form category was successfully created.' } }
          format.json { render :show, status: :created, location: @form_category }
        else
          format.html { render :new }
          format.json { render json: @form_category.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /form_categories/1
    # PATCH/PUT /form_categories/1.json
    def update
      respond_to do |format|
        if @form_category.update(form_category_params)
          format.html { redirect_to form_categories_path, flash: { success: 'Form category was successfully updated.' } }
          format.json { render :show, status: :ok, location: @form_category }
        else
          format.html { render :edit }
          format.json { render json: @form_category.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /form_categories/1
    # DELETE /form_categories/1.json
    def destroy
      @form_category.destroy
      respond_to do |format|
        format.html { redirect_to form_categories_path, flash: { success: 'Form category was successfully destroyed.' } }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_form_category
      @form_category = FormCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_category_params
      params.require(:form_category).permit(:name)
    end
  end
end
