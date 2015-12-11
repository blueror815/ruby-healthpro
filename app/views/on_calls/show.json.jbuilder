json.data do 
  json.set! :DT_RowId, @on_call.id
  json.set! :date, @on_call.date
  json.set! :payment_date, @on_call.note
end

