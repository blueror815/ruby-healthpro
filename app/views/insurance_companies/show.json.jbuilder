json.data do 
  json.set! :DT_RowId, "#{@insurance_company.id}"
  json.set! :name, @insurance_company.name
  json.set! :description, @insurance_company.description
end
