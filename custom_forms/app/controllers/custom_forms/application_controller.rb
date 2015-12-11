module CustomForms
  class ApplicationController < ActionController::Base
    
    include CustomForms
    before_action :set_layout
    before_action :authenticate_user!
    before_action :set_people_reports
    layout 'application'

    private

    #TODO_PROHEALTH refactor this method duplication 
    def set_people_reports
      @people_reports = Report.select{ |c| c.category== "HR"}
    end

    def get_model_attributes_names(model_name)
      return [] unless model_name.present?
      model_name.constantize.attribute_names
    end

    def get_form_attributes_names(form_id)
      return [] unless form_id.present?
      attributes_names = []
      custom_form = CustomForm.includes(form_sections: [section_fields: :field_type]).find(form_id)
      custom_form.form_sections.each do |section|
        section.section_fields.each do |field|
          attributes_names << ["#{section.title} - #{field.field_type.name.humanize}", field.field_type_id]
        end
      end
      attributes_names
    end

    def set_layout
      @controller_names = ['roles', 'agencies', 'job_types', 'departments', "reimbursements", "visit_types", "coverage_areas"]
      if (@controller_names.include? controller_name) && action_name == 'edit'
        @partial = 'layouts/edit'
      elsif (@controller_names.include? controller_name) && action_name == 'index'
        @partial = 'layouts/card_index'
      elsif (@controller_names.include? controller_name) && action_name == 'new'
        @partial = 'layouts/new'
      end
    end

    #TODO_PROHEALTH refactor this method duplication 
    def forms_fields(form, action)
      section_fields = []
      form.form_sections.each do |section|
        if section['permissions']["#{current_user.role.short_name}"][action] == '1'
          section_fields << section.section_fields.map do |field|
            if field.field_type.field_type.start_with?('select') && field.field_type.options['multivalue'] == '1'
              { field.id.to_s.to_sym => [] }
            else
              field.id.to_s.to_sym
            end
          end
        end
      end
      section_fields
    end
  end
end
