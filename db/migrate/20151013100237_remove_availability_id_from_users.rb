class RemoveAvailabilityIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :availability_id, :integer
  end
end
