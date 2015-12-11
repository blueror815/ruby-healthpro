class VisitDatatable < AjaxDatatablesRails::Base
  include ApplicationHelper
  def_delegator :@view, :link_to, :visit_path
  
  def sortable_columns
    @sortable_columns ||= ['Visit.progress_state', 'Visit.billing_state', 'Visit.billing_code', 
      'Visit.date', 'Visit.time_in', 'Visit.time_out', 'Agency.display_name', 
      'Patient.display_name', 'VisitType.title', 'User.display_name']
  end

  def searchable_columns
    @searchable_columns ||= ['Visit.progress_state', 'Visit.billing_state', 'Visit.billing_code', 
      'Visit.date', 'Visit.time_in', 'Visit.time_out', 'agencies.display_name', 
      'Patient.display_name', 'VisitType.title', 'User.display_name']
  end

  def v
    @view
  end

  private

  def data
    records.map do |record|
      time_in = format_time(record.time_in)
      time_out = format_time(record.time_out)
      assignee_name = record.assignee ? record.assignee.try(:display_name) : ''
      [
        record.progress_state, record.billing_state, 
        record.billing_code, record.date, time_in, 
        time_out, record.agency.try(:display_name), record.patient.try(:display_name), 
        record.visit_type.title, assignee_name,
        v.link_to('<i class="fa fa-eye"></i>'.html_safe, v.visit_path(record), class: "btn ink-reaction btn-icon-toggle btn-primary btn-xs")
      ]
    end
  end

  def get_raw_records
    Visit.includes(:assignee, :patient, :agency, :visit_type).references(:agency)
  end
end