json.array!(@visits) do |visit|
  json.extract! visit, :id, :medical_record_number, :progress_state, :billing_state, :billing_code, :date, :time_in, :time_out, :agency_id, :assigner_id, :assignee_id, :patient_id, :visit_type_id
  json.url visit_url(visit, format: :json)
end
