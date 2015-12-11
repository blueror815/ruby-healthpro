json.array!(@reports) do |report|
  json.extract! report, :id, :custom_form_id
  json.url report_url(report, format: :json)
end
