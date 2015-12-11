class AddTotalPaidToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :total_paid, :string
  end
end
