task scrape_data: [:environment] do
  Rake::Task[:scrape_agencies].invoke
  Rake::Task[:scrape_users].invoke
  Rake::Task[:scrape_users_agencies].invoke
  Rake::Task[:scrape_insurance_companies].invoke
  Rake::Task[:scrape_statuses].invoke
  Rake::Task[:scrape_patients].invoke
  Rake::Task[:scrape_patients_discharges_dates].invoke
  Rake::Task[:scrape_visits].invoke
end
