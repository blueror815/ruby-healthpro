task scrape_users: [:environment] do
  User.scrape_users
end
