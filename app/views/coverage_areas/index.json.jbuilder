json.array!(@coverage_areas) do |coverage_area|
  json.extract! coverage_area, :id, :name
  json.url coverage_area_url(coverage_area, format: :json)
end
