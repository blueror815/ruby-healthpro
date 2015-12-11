json.array!(@insurance_companies) do |insurance_company|
  json.extract! insurance_company, :id, :name, :description
  json.url insurance_company_url(insurance_company, format: :json)
end
