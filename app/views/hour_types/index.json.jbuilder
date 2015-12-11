json.array!(@hour_types) do |hour_type|
  json.extract! hour_type, :id, :name, :price
  json.url hour_type_url(hour_type, format: :json)
end
