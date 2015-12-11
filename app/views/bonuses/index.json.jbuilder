json.array!(@bonuses) do |bonuse|
  json.extract! bonuse, :id, :user_id, :price, :timesheet_id
  json.url bonuse_url(bonuse, format: :json)
end
