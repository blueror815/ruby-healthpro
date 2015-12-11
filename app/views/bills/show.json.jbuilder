json.data do 
  json.set! :DT_RowId, @bill.id
  json.set! :paied_amount, @bill.paied_amount
  json.set! :date, @bill.date
  json.set! :payment_date, @bill.payment_date
  json.set! :insurance_company_name, @bill.insurance_company.try(:name)
  json.set! :patient_name, @bill.patient.try(:display_name)
  json.set! :claim_type_name, @bill.claim_type.try(:name)
end

