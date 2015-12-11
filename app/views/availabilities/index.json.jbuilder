json.array!(@availabilities) do |availability|
  json.extract! availability, :id, :name, :description
  json.url availability_url(availability, format: :json)
end
