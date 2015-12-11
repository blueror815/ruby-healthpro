task scrape_visits: [:environment] do
  Visit.scrape_visits
end
