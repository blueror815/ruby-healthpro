json.array!(@license_types) do |license_type|
  json.extract! license_type, :id, :name, :code, :job_type_id
  json.url license_type_url(license_type, format: :json)
end
