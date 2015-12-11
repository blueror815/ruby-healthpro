class CreateJoinTableUserDepartment < ActiveRecord::Migration
  def change
    create_join_table :users, :departments do |t|
      t.index [:user_id, :department_id]
    end
  end
end
