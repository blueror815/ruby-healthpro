class AddColumnActionToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :action, :string
  end
end
