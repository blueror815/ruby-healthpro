class ReportBillDatatable < AjaxDatatablesRails::Base
  include ActionView::Helpers::NumberHelper
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= [
      'Bill.claim_start_date', 
      'Bill.claim_end_date', 
      'ClaimType.name',
      'InsuranceCompany.name', 
      'Patient.display_name', 
      'Bill.amount', 
      'Bill.date', 
    ]
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= [
      'Bill.claim_start_date', 
      'Bill.claim_end_date', 
      'ClaimType.name',
      'InsuranceCompany.name', 
      'Patient.display_name', 
      'Bill.amount', 
      'Bill.date', 
    ]
  end

  def v
    @view
  end

  private
    def date date
      if date
        date.strftime("%B %d, %Y")
      else
        "N/S"
      end
    end
    def data
      records.map do |record|
        soc_date = record.patient.try(:soc_date) ? date(record.patient.soc_date) : ""
        discharged_date =  record.patient.try(:discharged_date) ? date(record.patient.discharged_date) : ""
        bill_date = record.date ? date(record.date) : ""
        {
          'claim_start_date' => date(record.claim_start_date),
          'claim_end_date' => date(record.claim_end_date),
          'claim_type_name' => record.claim_type.try(:name),
          'insurance_company_name'=> record.insurance_company.try(:name),
          'patient_name'=> record.patient.try(:display_name),
          'amount' => number_to_currency(record.amount),
          'date' => bill_date,
          'claim_type_id' => record.claim_type.try(:id),
          'insurance_company_id' => record.insurance_company.try(:id),
          'patient_id'=> record.patient.try(:id),
          'note' => record.note,
          'paid_amount' => number_to_currency(record.paied_amount),
          'paid_date' => date(record.payment_date),
          'DT_RowId' =>  record.id.to_s,
          'action' => (v.link_to('<i class="fa fa-usd"></i>'.html_safe, v.new_payment_path(bill_id: record.id), class: "btn ink-reaction btn-icon-toggle btn-primary btn-xs", remote: true) +
              v.link_to('<i class="fa fa-eye"></i>'.html_safe, v.bill_path(record), class: "btn ink-reaction btn-icon-toggle btn-primary btn-xs")
            )
        }
      end
    end

    def get_raw_records
      if params[:from] && params[:to]
        Bill.includes(:patient, :claim_type, :insurance_company).references(:claim_type, :patient).
             range(params[:from], params[:to])
      else
        Bill.includes(:patient, :claim_type, :insurance_company).references(:claim_type, :patient)
      end
    end
end
