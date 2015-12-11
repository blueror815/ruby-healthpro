class UserDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to, :user_path
  def_delegator :@view, :concat, :tag

  def sortable_columns
    @sortable_columns ||= ['User.display_name', 'User.role']
  end

  def searchable_columns
    @searchable_columns ||= ['User.display_name']
  end

  private
    def data
      display_fields = {}
      records.map(&:form_data).flatten.each do |form_datum|
      
        form_datum.custom_form.form_sections.
        flatten.map(&:section_fields).flatten.each do |section_field|
          display_fields[section_field.form_section.custom_form_id] ||= []
          if section_field.index_display?
            display_fields[section_field.form_section.custom_form_id] << (section_field.id)
          end
        end
      end

      display_fields_tag = nil
      records.map do |record|
        filtered_form_data = {}
        record.form_data.each do |form|
          form_data = form.sections_data if form
          if form_data
            filtered_form_data.merge!(form_data.select {|k, v|  display_fields[form.custom_form_id] and display_fields[form.custom_form_id].include?(k.to_i)})
          end
        end
        field_types = records.map(&:form_data).flatten.map(&:custom_form).flatten.map(&:form_sections).flatten.map(&:section_fields).flatten#.map(&:field_type).flatten
        filtered_form_data = filtered_form_data.map { |k, v| [field_types.detect{|i| i.id == k.to_i}.field_alias, v] }

        shown_entries = [5, filtered_form_data.count].min #show only 5 elements
        display_fields_tag = v.content_tag(:div, class: 'col-md-4') do
          v.content_tag(:table, class: "table inner-table table-condensed no-margin text-xs") do
            shown_entries.times do |i|
              v.concat(v.content_tag(:tr, v.content_tag(:td, filtered_form_data[i].first.humanize, class: " text-xs text-default-light") + v.content_tag(:td, filtered_form_data[i].last)))
            end
            v.concat(v.content_tag(:tr, v.content_tag(:td, "Email", class: " text-sm text-default-light") + v.content_tag(:td, record.email)))
          end
        end
        job_type_title = record.job_type.try(:title) if record.job_type
        role_name = record.role.name if record.role
        user_info_tag = v.content_tag(:div, class: 'col-md-12') do
          v.content_tag(:table, class: "table inner-table table-condensed  no-margin text-sm") do
            v.content_tag(:tr, v.content_tag(:td, "Discipline", class: " text-sm text-default-light") + v.content_tag(:td, job_type_title)) +
            v.content_tag(:tr, v.content_tag(:td, "Agencies", class: " text-sm text-default-light", style:"width: 25%;") + v.content_tag(:td, record.agencies.map(&:display_name).to_sentence)) +
            v.content_tag(:tr, v.content_tag(:td, "Coverage areas", class: " text-sm text-default-light", style:"width: 25%;") + v.content_tag(:td, record.coverage_areas.map(&:name).to_sentence))+
            v.content_tag(:tr, v.content_tag(:td, "Availability", class: " text-sm text-default-light", style:"width: 25%;") + v.content_tag(:td, record.availabilities.map(&:name).join(', ')))
          end
        end
      department = record.departments.map(&:name).to_sentence if record.departments
      [
        v.content_tag(:div, class: 'row') do
          v.content_tag(:div, v.link_to(v.image_tag(record.image(:thumb), class: 'people-photo'), v.user_path(record), class: 'people-photo-container') + v.content_tag(:div, v.link_to(record.display_name || record.email, v.user_path(record)), class: 'truncate'), class: 'col-md-2 text-center') +
             display_fields_tag +
            v.content_tag(:div, class: 'col-md-6') do
              user_info_tag
            end
        end
      ]
    end
  end

  def get_raw_records
    User.includes(:role, :job_type, :departments, form_data: [custom_form: [form_sections: [section_fields: :field_type]]])
  end

  def v
    @view
  end

  private
  def empty_field?(field)
    if field.kind_of?(String)
      field == '-' || field == ''
    else
      field == nil
    end
  end
end
