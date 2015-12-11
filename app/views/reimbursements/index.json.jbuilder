json.array!(@reimbursements) do |reimbursement|
  json.extract! reimbursement, :id, :title, :value_type, :price
  json.url reimbursement_url(reimbursement, format: :json)
end
