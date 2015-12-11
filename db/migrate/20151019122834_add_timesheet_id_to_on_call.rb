class AddTimesheetIdToOnCall < ActiveRecord::Migration
  def change
    add_column :on_calls, :timesheet_id, :integer
  end
end
