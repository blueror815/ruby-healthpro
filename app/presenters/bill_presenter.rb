class BillPresenter < BasePresenter
  presents :bill
  
  def start_of_care_date
    soc_date = bill.claim_start_date || bill.patient.soc_date
    format_date(soc_date)
  end

  def end_of_care_date
    discharged_date = bill.claim_end_date || bill.patient.discharged_date
    format_date(discharged_date)
  end

  private

  def format_date(date_obj = nil)
    date_obj ? date_obj.strftime("%d %b %Y") : 'not provided'
  end

end