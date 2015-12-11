task scrape_agencies: [:environment] do
  Agency.scrape_agency
end
