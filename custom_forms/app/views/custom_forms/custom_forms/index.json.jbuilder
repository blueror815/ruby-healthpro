json.array!(@custom_forms) do |custom_form|
  json.extract! custom_form, :id, :title, :permissions, :sections
  json.url custom_form_url(custom_form, format: :json)
end
