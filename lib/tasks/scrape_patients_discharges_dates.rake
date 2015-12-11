task scrape_patients_discharges_dates: [:environment] do
  Patient.scrape_discharged_dates
end
