class PaymentsSummaryDatatable < AjaxDatatablesRails::Base
  def sortable_columns
    @sortable_columns ||= [
      "Patient.soc_date",
      "Patient.discharged_date",
      "InsuranceCompany.name",
      "Patient.display_name",
      "Payment.amount",
      "Payment.date",
      "ClaimType.name"
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
      "Patient.soc_date",
      "Patient.discharged_date",
      "InsuranceCompany.name",
      "Patient.display_name",
      "Payment.amount",
      "Payment.date",
      "ClaimType.name"
    ]
  end

  def from
    options[:from] ||  StringFormatter.format_date(Date.today.beginning_of_week)
  end

  def to
    options[:to] ||  StringFormatter.format_date(Date.today.end_of_week)
  end

  def on
    options[:on] ||  StringFormatter.format_date(Date.today)
  end

  def v
    @view
  end
       

  private
    def data
      records.map do |payment|
        {
          soc_date: payment.bill.claim_start_date ? StringFormatter.format_date(payment.bill.claim_start_date) : "" ,
          discharge_date: payment.bill.claim_end_date ?  StringFormatter.format_date(payment.bill.claim_end_date) : "",
          payor: payment.bill.insurance_company.name,
          patient: payment.bill.display_name,
          amount: StringFormatter.format_currency(payment.amount),
          payment_date: payment.date,
          claim: payment.bill.claim_type.name
        }
      end
    end

    def get_raw_records
      if on
        Payment.includes(:patient, bill: [:claim_type, :insurance_company]).references(:claim_type).
                where(date: on).references(:patient, bill: [:claim_type, :insurance_company])
      else
        Payment.includes(:patient, bill: [:claim_type, :insurance_company]).references(:claim_type).
                where(date: from..to).references(:patient, bill: [:claim_type, :insurance_company])
      end
    end
end