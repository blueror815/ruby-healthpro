json.array!(@form_categories) do |form_category|
  json.extract! form_category, :id, :name
  json.url form_category_url(form_category, format: :json)
end
