class PatientDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to, :patient_path

  def sortable_columns
    @sortable_columns ||= ['Patient.display_name']
  end

  def searchable_columns
    @searchable_columns ||= ['Patient.display_name']
  end

  private

  def data
    records.map do |record|
      agency = record.agency.display_name if record.agency
      patient_info_tag = v.content_tag(:div, class: 'col-md-5') do
        v.content_tag(:table, class: "table inner-table table-condensed  no-margin text-xs") do
          v.content_tag(:tr, v.content_tag(:td, "Name", class: "text-right text-xs text-default-light", style:"width: 25%;") + v.content_tag(:td, record.display_name)) +
          v.content_tag(:tr, v.content_tag(:td, "Patient ID", class: "text-right text-xs text-default-light") + v.content_tag(:td, record.devero_id)) +
          v.content_tag(:tr, v.content_tag(:td, "Email", class: "text-right text-xs text-default-light") + v.content_tag(:td, record.email)) +
          v.content_tag(:tr, v.content_tag(:td, "Agency", class: "text-right text-xs text-default-light") + v.content_tag(:td, agency)) +
          v.content_tag(:tr, v.content_tag(:td, "Insurances", class: "text-right text-xs text-default-light") + v.content_tag(:td, record.insurance_companies.map(&:name).join(', ')))
        end
      end
      
      status = record.status.title if record.status
      [
        v.content_tag(:div, class: 'row') do
          v.content_tag(:div, v.link_to(v.image_tag(record.image(:thumb), class: "people-photo"), v.patient_path(record)) + v.content_tag(:div, v.link_to(record.display_name || record.email, v.patient_path(record)), class: "truncate text-xs") , class: "col-md-2 text-center") + 
          patient_info_tag +
          v.content_tag(:div, class: 'col-md-5') do
            "" #TODO: add patients viewable columns
          end
        end
      ]
    end
  end

  def get_raw_records
    Patient.includes(:agency)
  end

  def v
    @view
  end
end