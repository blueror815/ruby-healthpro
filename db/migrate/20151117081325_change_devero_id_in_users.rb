class ChangeDeveroIdInUsers < ActiveRecord::Migration
  def change
    change_column :users, :devero_id, :string
  end
end
