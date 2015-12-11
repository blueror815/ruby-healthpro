class ReceivablesDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to, :bill_path
 
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= [
      'Bill.id',
      'Bill.claim_start_date',
      'Bill.claim_end_date',
      'ClaimType.name',
      'InsuranceCompany.name',
      'Patient.display_name',
      'Bill.amount',
      'Bill.date',
      'Bill.payment_date',
      'Bill.paied_amount'
    ]
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= [
      'Bill.id',
      'Bill.claim_start_date',
      'Bill.claim_end_date',
      'ClaimType.name',
      'InsuranceCompany.name',
      'Patient.display_name',
      'Bill.amount',
      'Bill.date',
      'Bill.payment_date',
      'Bill.paied_amount'
    ]
  end

  def v
    @view
  end

  private
    def data
      records.map do |record|
          soc_date = record.try(:patient).try(:soc_date) ? date(record.try(:patient).try(:soc_date)) : ""
          discharged_date =  record.try(:patient).try(:discharged_date) ? date(record.try(:patient).try(:discharged_date)) : ""
        {
          'id' => v.link_to(record.id, v.bill_path(record.id)),
          'claim_start_date' => date(record.claim_start_date),
          'claim_end_date' => date(record.claim_end_date),
          'claim_type_name'=> record.claim_type.try(:name),
          'insurance_company_name'=> record.insurance_company.try(:name),
          'patient_name' => record.patient.try(:display_name),
          'amount' => StringFormatter.format_currency(record.amount),
          'date'=> date(record.date),
          'paid_amount' => StringFormatter.format_currency(record.paied_amount),
          'paid_date' => date(record.payment_date)
        }
      end
    end

    def date date
      if date
        StringFormatter.format_date(date)
      else
        "N/S"
      end
    end

    def get_raw_records
      if params[:payment_state] && params[:payment_state] == 'no_payment'
        Bill.no_payment.includes(:patient, :claim_type, :insurance_company).
           range(params[:from], params[:to]).
           references(:patient, :claim_type, :insurance_company)
      else #default - partially paid
        Bill.receivables.includes(:patient, :claim_type, :insurance_company).
           range(params[:from], params[:to]).
           references(:patient, :claim_type, :insurance_company)
      end
    end
end
