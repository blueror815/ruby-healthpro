class BillDatatable < AjaxDatatablesRails::Base
  include ActionView::Helpers::NumberHelper

  def cols
    [
      'Bill.claim_start_date', 
      'Bill.claim_end_date', 
      'ClaimType.name',
      'InsuranceCompany.name', 
      'Patient.display_name', 
      'Bill.amount', 
      'Bill.date', 
      'Bill.paied_amount', 
      'Bill.payment_date'
    ]
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= cols
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= cols
  end

  def v
    @view
  end

  private
    def date date
      if date
        StringFormatter.format_date(date)
      else
        "N/S"
      end
    end

    def data
      records.map do |record|
        soc_date = record.claim_start_date || record.try(:patient).try(:soc_date) || ''
        discharged_date =  record.claim_end_date || record.try(:patient).try(:discharged_date) || ''
        bill_date = record.date ? date(record.date) : ""
        {
          claim_type_id: record.claim_type.try(:id),
          insurance_company_id: record.insurance_company.try(:id),
          patient_id: record.patient.try(:id),
          date: bill_date,
          patient_name: record.patient.try(:display_name),
          claim_type_name: record.claim_type.try(:name),
          amount_in_dollars: number_to_currency(record.amount),
          amount: record.amount,
          claim_start_date: date(soc_date),
          claim_end_date: date(discharged_date),
          note: record.note,
          paid_amount: number_to_currency(record.paied_amount),
          paid_date: date(record.payment_date),
          insurance_company_name: record.insurance_company.try(:name),
          :"DT_RowId" => record.id.to_s,
          action: (v.link_to('<i class="fa fa-usd"></i>'.html_safe, v.new_payment_path(bill_id: record.id), class: "btn ink-reaction btn-icon-toggle btn-primary btn-xs", remote: true) +
              v.link_to('<i class="fa fa-eye"></i>'.html_safe, v.bill_path(record), class: "btn ink-reaction btn-icon-toggle btn-primary btn-xs")
            )
        }
      end
    end

    def get_raw_records
      if params[:type] == 'aging'
        Bill.includes(:patient, :claim_type, :insurance_company).references(:patient).range(params[:from], params[:to]).receivables
      elsif params[:from] && params[:to]
        Bill.includes(:patient, :claim_type, :insurance_company).references(:patient).range(params[:from], params[:to])
      else
        Bill.includes(:patient, :claim_type, :insurance_company).references(:patient)
      end
    end
end
