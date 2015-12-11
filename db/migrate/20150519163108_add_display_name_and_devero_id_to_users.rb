class AddDisplayNameAndDeveroIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :display_name, :string
    add_column :users, :devero_id, :integer
  end
end
