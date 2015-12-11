class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :coverage_areas do |t|
      t.index [:user_id, :coverage_area_id]
      t.index [:coverage_area_id, :user_id]
    end
  end
end
