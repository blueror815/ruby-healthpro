class AddPreviousVisitsAvgToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :previous_visits_avg, :string, default: 0
    Timesheet.all.each do |timesheet|
      timesheet.previous_visits_avg = 0 
      timesheet.save!
    end
  end
end
