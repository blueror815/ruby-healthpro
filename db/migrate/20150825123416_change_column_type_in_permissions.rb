class ChangeColumnTypeInPermissions < ActiveRecord::Migration
  def change
    change_column :permissions, :conditions, :string
  end
end
