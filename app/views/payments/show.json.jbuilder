json.data do 
  json.set! :"DT_RowId", @payment.id
  json.set! :date, @payment.date
  json.set! :amount, @payment.amount
  json.set! :patient_soc_date, @payment.patient.try(:soc_date)
  json.set! :patient_discharged_date, @payment.patient.try(:discharged_date)
  json.set! :payment_type_name, @payment.payment_type.try(:name)
end

