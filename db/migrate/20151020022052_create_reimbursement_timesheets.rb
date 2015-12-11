class CreateReimbursementTimesheets < ActiveRecord::Migration
  def change
    create_table :reimbursement_timesheets do |t|
      t.integer :reimbursement_id
      t.integer :timesheet_id
      t.string :progress_state
      t.integer :action_count
      t.string :comment

      t.timestamps null: false
    end
  end
end
