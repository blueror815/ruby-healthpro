class AddTimesheetIdToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :timesheet_id, :integer
  end
end
