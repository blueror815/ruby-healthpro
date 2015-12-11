task scrape_patients: [:environment] do
  Patient.scrape_patients
end
