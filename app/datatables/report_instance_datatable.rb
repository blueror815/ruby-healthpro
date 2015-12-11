class ReportInstanceDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= []
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['User.display_name', 'CustomForms::SectionField.field_alias']
  end

  def v
    @view
  end

  private
    def data
      set_rows(records).map do |record|
        {
          model: record[:user] + v.content_tag(:span, '') + v.content_tag(:span, record[:frequency]),
          field: v.content_tag(:span, record[:field_name]),
          value: record[:value],
          count: ''
        }
      end
    end

    def get_raw_records
      result = {}
      result = Report.report_data(params)
      @field_frequency = result[:field_frequency]
      @section_fields = result[:section_fields]
      @form_data = result[:form_data]
      @report = result[:report]
      result[:data]
    end

    def set_rows(records)
      include_empty = @report.report_fields.first.value_options['include_empty'] == '0' ? false : true
      field_type = @report.report_fields.first.field_type
      objs = []
      records.each do |form_datum|
        @field_frequency[form_datum.id].each do |k, v|
          if k != 'empties_count' && field = @section_fields.detect{ |f| f.id == k.to_i }
            row = {}
            row[:user_id] = form_datum.user_id
            row[:user] = form_datum.user.display_name
            frequency = @field_frequency[form_datum.id].keys.include?('empties_count') ? @field_frequency[form_datum.id].length - 1 : @field_frequency[form_datum.id].length
            if include_empty
              missing = @field_frequency[form_datum.id]['empties_count'].to_i
              if ['file', 'boolean', 'date'].include?field_type
                row[:frequency] = "#{ missing } Missing Document(s)"
              else
                row[:frequency] = "Expired: #{ frequency - missing }, Missing: #{ missing }"
              end
            else
              row[:frequency] = frequency
            end

            row[:field_name] = field.field_alias
            if field.field_type.field_type == 'boolean'
              row[:value] = v.to_s == "0" ? 'false' : 'true'
            elsif ['file', 'expirable_file'].include? field.field_type.field_type
              row[:value] = file_field(form_datum, k, field.field_type.field_type)
            else
              row[:value] = v
            end

            if row[:value]
              objs << row
            end
          end
        end
      end
      objs
    end

    # TODO_PROHEALTH move to an abstract level so it can be used anywhere 
    def file_field(form_datum, k, file_type)
      file = form_datum.attachments.detect{ |a| a.section_field_id.to_s == k.to_s}
      file_text = file_type == 'expirable_file' ? (file.try(:expiration_date) || '') : ''
      unless file && file.file.url.include?('placeholder.jpg')
        file ? (link_to file_text, file.file.url, download: file, class: 'fa fa-download') : '-'
        # if file_type == "file"
        #   'empty file'
        # else
        #   file ? (link_to file_text, file.file.url, download: file, class: 'fa fa-download') : '-'
        # end
      else
        'No Document Attached'
      end
    end
end
