class RemoveRoleAndIsAdminFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :role
    remove_column :users, :is_admin
  end

  def down
    add_column :users, :role, :string
    add_column :users, :is_admin, :boolean
  end
end
