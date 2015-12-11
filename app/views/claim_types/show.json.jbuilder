json.data do 
  json.set! :DT_RowId, @claim_type.id
  json.set! :name, @claim_type.name
  json.set! :description, @claim_type.description
end
