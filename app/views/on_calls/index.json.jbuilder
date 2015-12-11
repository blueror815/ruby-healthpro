json.data do 
  json.array!(@on_calls) do |on_call|
    json.set! :DT_RowId, "#{on_call.id}"
    json.set! :note, on_call.note
    json.set! :date, on_call.date
  end
end

