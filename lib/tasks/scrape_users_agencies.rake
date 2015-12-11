task scrape_users_agencies: [:environment] do
  User.scrape_users_agencies
end
