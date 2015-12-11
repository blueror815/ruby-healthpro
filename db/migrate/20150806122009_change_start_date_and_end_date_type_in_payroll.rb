class ChangeStartDateAndEndDateTypeInPayroll < ActiveRecord::Migration
  def change
    change_column :payrolls, :start_date, :datetime
    change_column :payrolls, :end_date, :datetime
  end
end
