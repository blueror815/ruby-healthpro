class AddTimesheetIdAndTotalPriceToHour < ActiveRecord::Migration
  def change
    add_column :hours, :timesheet_id, :integer
    add_column :hours, :total_price, :string
  end
end
