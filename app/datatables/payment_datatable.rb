class PaymentDatatable < AjaxDatatablesRails::Base
  def table_required_columns
    if params[:bill_view] && params[:bill_view] == 'true'
       [
      'Payment.date', 
      'Payment.amount' 

      ]
    else
       [
      'Bill.claim_start_date', 
      'Bill.claim_end_date', 
      'InsuranceCompany.name', 
      'Patient.display_name',
      'Payment.amount', 
      'Payment.date', 
      'ClaimType.name' 
      ]
    
    end
  end
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= table_required_columns
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||=  table_required_columns
  end

  def v
    @view
  end

  private
    def data
      records.map do |record|
        {
          patient_soc_date: record.bill.patient.try(:soc_date),
          patient_discharged_date: record.bill.patient.try(:discharged_date),
          claim_start_date:  StringFormatter.format_date(record.bill.try(:claim_start_date)),
          claim_end_date: StringFormatter.format_date(record.bill.try(:claim_end_date)),
          patient_name: record.bill.patient.try(:display_name),
          payment_type_name: record.payment_type.try(:name),
          payment_type_id: record.payment_type.try(:id),
          payor: record.insurance_company.try(:name),
          claim_type_name: record.bill.claim_type.name,
          amount: StringFormatter.format_currency(record.amount),
          date:  StringFormatter.format_date(record.date),
          action: v.link_to(
            '<i class="fa fa-trash"></i>'.html_safe, '#',
            class: "btn ink-reaction btn-icon-toggle btn-primary btn-xs editor_remove"),
          :"DT_RowId" => record.id
        }
      end
    end

    def get_raw_records
      if params[:from] && params[:to]
        Payment.includes(:patient, :claim_type, :insurance_company, :bill).references(:claim_type, :bill, :insurance_company).range(params[:from], params[:to])
      elsif params[:bill_id]
        Bill.find(params[:bill_id]).payments.includes(:patient, :claim_type, :insurance_company, :bill).references(:claim_type, :bill, :insurance_company)
      else
        Payment.includes(:patient, :claim_type, :insurance_company, :bill).references(:claim_type, :bill, :insurance_company)
      end
    end
end
