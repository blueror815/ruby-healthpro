class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :generate_instance]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
    @report.report_fields.build
  end

  # GET /reports/1/edit
  def edit
    search_field = @report.report_fields.first.field_type
    set_field_types(search_field, @report.custom_form_id)

    set_field_aliases(search_field,  @report.custom_form_id, @report.report_fields.last.field_type_ids.uniq)
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to reports_path, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to reports_path, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_path, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def generate_instance
    respond_to do |format|
      format.html
      format.json { render json: ReportInstanceDatatable.new(view_context)}
      format.xls 
    end
  end

  def export
    @report = Report.includes(:report_fields).find(params[:id])
    @data = Report.report_data(params)
    data = Spreadsheet::Workbook.new
    filename = "#{@report.name}_#{Date.today.strftime('%d_%m_%Y')}.xls"
    respond_to do |format|
      format.xls { send_data(Report.to_csv(@data), filename: filename) }
    end
  end

  def get_search_field(field_type = params[:field_type])
    search_field = if field_type.start_with?("date"  )
      "date"
    else
      field_type
    end
    search_field
  end

  # get field types for report by custom form & field type
  def get_form_fields
    search_field = get_search_field(params[:field_type])
    set_field_types(search_field, params[:custom_form_id])
    respond_to do |format|
      format.js
    end
  end

  def get_field_aliases
    report_field_aliases(params[:field_type], params[:custom_form_id], params[:field_aliases_ids])
    respond_to do |format|
      format.js
    end
  end

  # get field basic types by custom form 
  def get_field_basic_types
    custom_form = CustomForms::CustomForm.find(params[:custom_form_id])
    @basic_field_types = custom_form.basic_field_types
    respond_to do |format|
      format.js
    end
  end

  private


    # prepare report field aliases 
    def report_field_aliases(field_type, custom_form_id, field_aliases_ids)
      search_field = get_search_field(field_type)
      set_field_aliases(search_field, custom_form_id, field_aliases_ids)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.includes(:report_fields).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:custom_form_id, :name,
                                    report_fields_attributes:
                                    [:id, :field_type, :field_value, field_type_ids: [], 
                                    field_aliases: [], value_options: [:from, :to, :days, :include_empty]])
    end

    # get field types records by custom_form_id and filed type
    def set_field_types(search_field, custom_form_id)
      @field_types = CustomForms::CustomForm.find(custom_form_id).form_sections.
                                            map(&:section_fields).flatten.map(&:field_type).
                                            select{|f| f.field_type == search_field}.uniq
    end

    def set_field_aliases(search_field, custom_form_id, field_aliases_ids = nil)
      section_fields = CustomForms::CustomForm.find(custom_form_id).form_sections.map(&:section_fields)
      field_type_ids = section_fields.flatten.map(&:field_type).select{|f| f.field_type == search_field}.map(&:id)
      @field_aliases = section_fields.flatten.select{|f| field_type_ids.include?f.field_type_id}
      if field_aliases_ids
        @field_aliases = @field_aliases.select{|f| field_aliases_ids.map(&:to_s).include?f.field_type_id.to_s}
      end
      @field_aliases.uniq
    end
end
