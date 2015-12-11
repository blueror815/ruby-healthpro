json.items do 
  json.array!(@patients) do |patient|
    json.set! :display_name, patient.try(:display_name)
    json.set! :id, patient.id
  end
end

