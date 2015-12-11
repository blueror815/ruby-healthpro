json.data do 
  json.set! :DT_RowId, @availability.id
  json.set! :name, @availability.name
  json.set! :description, @availability.description
end
