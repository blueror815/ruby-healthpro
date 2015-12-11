json.array!(@agencies) do |agency|
  json.extract! agency, :id, :phone, :fax, :zipcode, :state, :city, :devero_id, :display_name, :short_name, :address, :address2, :email, :name, :medicare_provider_number, :hha_agency_id, :rate, :fax_service_username, :fax_service_account_id, :timezone
  json.url agency_url(agency, format: :json)
end
