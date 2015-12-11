task scrape_statuses: [:environment] do
  Status.scrape_statuses
end
