class AddReadColumnToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :read, :boolean, default: false
    add_index  :notifications, :receiver_id
    add_index  :notifications, [:receiver_id, :read]
  end
end
