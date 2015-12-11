task scrape_patients_insurances: [:environment] do
  Patient.scrape_patients_insurances
end
