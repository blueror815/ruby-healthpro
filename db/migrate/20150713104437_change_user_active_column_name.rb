class ChangeUserActiveColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :active, :inactive
  end
end
