class CreateJoinTableAvailabilitiesUsers < ActiveRecord::Migration
  def change
    create_join_table :availabilities, :users do |t|
      t.index [:availability_id, :user_id]
      t.index [:user_id, :availability_id]
    end
  end
end
