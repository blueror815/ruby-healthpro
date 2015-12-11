class AddTimeInAndTimeOutToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :time_in, :time
    add_column :visits, :time_out, :time
  end
end
