class Report < ActiveRecord::Base
  # associations 
  has_many :report_fields, dependent: :destroy
  belongs_to :custom_form, class_name: 'CustomForms::CustomForm'

  accepts_nested_attributes_for :report_fields

  # validations 
  validates :name, presence: true
  validates :custom_form_id, presence: true

  def category
    CustomForms::CustomForm.find(custom_form_id).form_category.try(:name)
  end

  # class methods
  def self.to_csv(records)
    attributes = ['Model', 'Field', 'Value', 'Count']

    CSV.generate do |csv|
      csv << attributes
      records[:form_data].each do |form_datum|
        csv << [ 
                form_datum.user.display_name,
                '',
                '',
                records[:field_frequency][form_datum.id].length
               ]
        records[:field_frequency][form_datum.id].each do |k, v|
          field = records[:section_fields].detect{ |f| f.id == k.to_i}
          if field.field_type.field_type == 'boolean'
            val = v == "0" ? false : true
          else
            val = v
          end
          csv << [
            '',
            field.field_alias,
            val,
            ''
          ]
        end
      end
    end
  end

  def self.report_data(params = {})
    field_types, section_field_ids, forms, section_fields, options = set_search_basic_params(params)

    field_frequency = {}
    form_data, field_frequency  = prepare_report_query_data(field_types, forms, field_frequency, section_field_ids, options)

    result = set_report_result(form_data, field_frequency, section_fields, @report)
  end

  def self.set_report_result(form_data, field_frequency, section_fields, report)
    data = CustomForms::FormDatum.where(id: form_data.map(&:id)).includes(:attachments, :user, custom_form: [form_sections: [section_fields: :field_type]]).
                                references(:user, custom_form: [form_sections: [section_fields: :field_type]])
    result = {}
    result[:form_data] = form_data
    result[:field_frequency] = field_frequency
    result[:section_fields] = section_fields
    result[:data] = data
    result[:report] = report
    result
  end

  #TODO_PROHEALTH needs to be refactored 
  def self.prepare_report_query_data(field_types, forms, field_frequency, section_field_ids, options)
    form_data, field_frequency = if field_types.first.field_type == "boolean"
      set_boolean_forms(forms, field_frequency, section_field_ids)
    elsif field_types.first.field_type == "file"
      set_file_forms(forms, field_frequency, section_field_ids, options)
    elsif field_types.first.field_type == "expirable_file"
      set_expirable_file_forms(forms, field_frequency, options, section_field_ids)
    elsif field_types.first.field_type.start_with?"date"
       set_date_forms(forms, field_frequency, options, section_field_ids)
    end
    [form_data, field_frequency]
  end

  def self.set_search_basic_params(params)
    @report = Report.includes(:report_fields).find(params[:id])
    search_field = @report.report_fields.first.field_type
    search_field = "date" if search_field.start_with?"date"
    section_fields = @report.custom_form.form_sections.map(&:section_fields).flatten
    field_types = section_fields.map(&:field_type).flatten.uniq.select{ |f| f.field_type == search_field }
    # set fields 
    section_field_ids = if alias_name_is_valid
                          section_fields.select{|f| @report.report_fields.first.field_aliases.include? f.field_alias}.map(&:id)
                        else
                          field_types.map(&:section_fields).flatten.uniq.map(&:id)
                        end
    forms = CustomForms::FormDatum.where(custom_form_id: @report.custom_form_id).
                                    includes(:attachments, :user, custom_form: 
                                            [form_sections: [section_fields: :field_type]])
    options = @report.report_fields.first.value_options
    return field_types, section_field_ids, forms, section_fields, options
  end

  def self.alias_name_is_valid
    @report.report_fields.first.field_aliases.reject { |c| c.empty? }.any?
  end

  def self.set_boolean_forms(forms, field_frequency, section_field_ids)
    forms = forms.select do |form|
                   fields = form.sections_data.select{ |k, v| @report.report_fields.first.field_value.include?(v.to_s) && section_field_ids.include?(k.to_i) }
                   if fields.any?
                     field_frequency[form.id] = fields
                     true
                   else
                     false
                   end
                 end
    return forms, field_frequency
  end

  def self.set_file_forms(forms, field_frequency, section_field_ids, options)
    include_empty = options['include_empty'].to_i == 1 ? true : false
    included_section_field_ids = []
    forms = forms.select do |form|
                   empties_count = 0
                   fields = form.sections_data.select do |k, v|
                              k = k.to_i
                              if section_field_ids.include?(k)
                                included_section_field_ids << k
                                if !form.attachments.detect{ |a| a.section_field_id == k }.try(:file).try(:exists?)
                                  if include_empty 
                                    empties_count += 1
                                  end
                                else
                                  true
                                end
                             end
                           end

                   if fields.any?
                     field_frequency[form.id] = fields
                     field_frequency[form.id]['empties_count'] = empties_count if include_empty
                     true
                   else
                     response, field_frequency = check_form_recently_added_fields(empties_count, include_empty, included_section_field_ids, section_field_ids, field_frequency, 'file', form)
                     response
                   end
                 end
    return forms, field_frequency
  end

  def self.check_form_recently_added_fields(empties_count, include_empty, included_section_field_ids, section_field_ids, field_frequency, field_type, form)
    response = false
    if include_empty
      if included_section_field_ids.length < section_field_ids.length
        missings = section_field_ids - included_section_field_ids
        field_frequency[form.id] = Hash[missings.map{|m| [m, field_type]}]
        empties_count += field_frequency[form.id].length
      end
      response = true

      field_frequency[form.id] ||= {}
      field_frequency[form.id]['empties_count'] = empties_count
    end
    return response, field_frequency
  end

  def self.set_date_forms(forms, field_frequency, options, section_field_ids)
    include_empty = options['include_empty'].to_i == 1 ? true : false
    included_section_field_ids = []
    forms = forms.select do |form|
              empties_count = 0
              fields = form.sections_data.select do |k, v|
                k = k.to_i
                if section_field_ids.include?(k)
                   included_section_field_ids << k
                  _break = true if !include_empty && (v.nil? || v.to_i == 0)
                  unless _break
                    empties_count, matched = filter_matched_dates_forms(options, include_empty, v, empties_count)
                    matched
                  end
                end
              end
              if fields && fields.any?
                field_frequency[form.id] = fields
                field_frequency[form.id]['empties_count'] = empties_count
                true
              else
                response, field_frequency = check_form_recently_added_fields(empties_count, include_empty, included_section_field_ids, section_field_ids, field_frequency, '', form)
                response
              end
            end
    return forms, field_frequency
  end

  def self.set_expirable_file_forms(forms, field_frequency, options, section_field_ids)
    include_empty = options['include_empty'].to_i == 1 ? true : false
    included_section_field_ids = []
    forms = forms.select do |form|
              empties_count = 0
              matches = []
              matched_field = []
              fields = form.sections_data.select do |k, v|
                k = k.to_i
                if section_field_ids.include?(k)
                  included_section_field_ids << k
                  attachment = form.attachments.detect{ |a| a.section_field_id == k }
                  _break = true if !include_empty && attachment.try(:expiration_date).nil?
                  unless _break
                    expiration_date, empties_count, from_date, to_date = set_expirable_files_form_matching_params(options, include_empty, attachment, empties_count)
                    matched, matches, field_frequency = filter_matched_expirable_files_forms(empties_count, to_date, expiration_date, from_date, field_frequency, k, v, matches, attachment, form)
                    matched
                  end
                end
              end
              if matches.any?
                true
              else
                response, field_frequency = check_form_recently_added_fields(empties_count,include_empty, included_section_field_ids, section_field_ids, field_frequency, 'expirable_file', form)
                response
              end
            end
    return forms, field_frequency
  end

  def self.filter_matched_dates_forms(options, include_empty, v, empties_count)
    if options['days'].present?
      if options['days'].to_i == 0
        from_date = Date.civil
      else
        from_date = Date.today
      end
      to_date = Date.today + options['days'].to_i.days
    else
      from_date = options['from'].blank? ? Date.civil : options['from'].to_date
      to_date = options['to'].blank? ? Date.today : options['to'].to_date
    end
    if include_empty && (v.nil? || v.to_i == 0)
      empties_count += 1
      v = to_date - 1.day
    end
    return empties_count, to_date > v.to_date && from_date < v.to_date
  end

  def self.set_expirable_files_form_matching_params(options, include_empty, attachment, empties_count)
    if options['days'].to_i == 0
      from_date = Date.civil
    else
      from_date = Date.today
    end
    to_date = Date.today + options['days'].to_i.days
    expiration_date = attachment.try(:expiration_date)
    if include_empty && expiration_date.blank?
      empties_count += 1
      expiration_date = to_date - 1.day
    end
    return expiration_date, empties_count, from_date, to_date
  end

  def self.filter_matched_expirable_files_forms(empties_count, to_date, expiration_date, from_date, field_frequency, k, v, matches, attachment, form)
    matched = false
    if to_date > expiration_date && from_date < expiration_date
      matches << attachment
      if field_frequency[form.id]
        field_frequency[form.id].merge!(k => v)
      else
        field_frequency[form.id] = {k => v}
      end
      field_frequency[form.id]['empties_count'] = empties_count
      matched = true
    end
    return matched, matches, field_frequency
  end
end
