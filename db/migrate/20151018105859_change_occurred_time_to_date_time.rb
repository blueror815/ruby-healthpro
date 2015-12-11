class ChangeOccurredTimeToDateTime < ActiveRecord::Migration
  def up
    remove_column :visits, :assigned_time
    remove_column :visits, :occurred_time
    remove_column :visits, :time_in
    remove_column :visits, :time_out
    add_column :visits, :assigned_time, :datetime
    add_column :visits, :occurred_time, :datetime
    add_column :visits, :time_in, :datetime
    add_column :visits, :time_out, :datetime
  end

  def down
    remove_column :visits, :assigned_time
    remove_column :visits, :occurred_time
    remove_column :visits, :time_in
    remove_column :visits, :time_out
    add_column :visits, :assigned_time, :time
    add_column :visits, :occurred_time, :time
    add_column :visits, :time_in, :time
    add_column :visits, :time_out, :time
  end

end
