json.array!(@job_types) do |job_type|
  json.extract! job_type, :id, :job_class
  json.url job_type_url(job_type, format: :json)
end
