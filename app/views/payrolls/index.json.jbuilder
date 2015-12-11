json.array!(@payrolls) do |payroll|
  json.extract! payroll, :id, :start, :end
  json.url payroll_url(payroll, format: :json)
end
