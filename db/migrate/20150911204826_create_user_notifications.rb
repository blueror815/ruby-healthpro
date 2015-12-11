class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :sender_id
      t.integer :notification_id

      t.timestamps null: false
    end
  end
end
