json.data do 
  json.array!(@hours) do |hour|
    json.set! :DT_RowId, "#{hour.id}"
    json.set! :hours, hour.hours
    json.set! :hour_type_id, hour.hour_type_id
    json.set! :progress_state, hour.progress_state
  end
end
