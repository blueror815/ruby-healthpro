class AddUserIdToOnCall < ActiveRecord::Migration
  def change
    add_column :on_calls, :user_id, :integer
  end
end
