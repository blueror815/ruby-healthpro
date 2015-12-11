json.fieldErrors do
  @insurance_company.errors.each do |name, error|
    json.child! do
      json.name name
      json.status error
    end
  end
end
