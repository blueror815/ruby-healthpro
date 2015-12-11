class AddIncludeInTimesheetToReimbursement < ActiveRecord::Migration
  def change
    add_column :reimbursements, :include_in_timesheet, :boolean
  end
end
