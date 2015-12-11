json.fieldErrors do
  @availability.errors.each do |name, error|
    json.child! do
      json.name name
      json.status error
    end
  end
end
