class ChangeTimeInAndTimeOutToAssignedTimeAndActionTime < ActiveRecord::Migration
  def change
    rename_column :visits, :time_in, :assigned_time
    rename_column :visits, :time_out, :occurred_time
  end
end
