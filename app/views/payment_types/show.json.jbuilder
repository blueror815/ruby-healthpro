json.data do 
  json.set! :'DT_RowId', @payment_type.id
  json.set! :name, @payment_type.name
  json.set! :description, @payment_type.description
end
