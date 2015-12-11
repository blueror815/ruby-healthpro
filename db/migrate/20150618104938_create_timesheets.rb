class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer :user_id
      t.integer :payroll_id

      t.timestamps null: false
    end
  end
end
