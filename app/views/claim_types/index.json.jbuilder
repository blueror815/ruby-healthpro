json.array!(@claim_types) do |claim_type|
  json.extract! claim_type, :id, :name, :description
  json.url claim_type_url(claim_type, format: :json)
end
