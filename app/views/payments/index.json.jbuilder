json.data do 
  json.array!(@payments) do |payment|
    json.set! :DT_RowId, "#{payment.id}"
    json.set! :date, payment.date
    json.set! :patient_name, payment.patient.try(:display_name)
    json.set! :claim_type_name, payment.claim_type.name
  end
end

