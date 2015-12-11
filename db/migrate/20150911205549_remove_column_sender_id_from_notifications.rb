class RemoveColumnSenderIdFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :sender_id, :integer
  end
end
