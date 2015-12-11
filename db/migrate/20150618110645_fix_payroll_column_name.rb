class FixPayrollColumnName < ActiveRecord::Migration
  def change
    rename_column :payrolls, :start, :start_date
    rename_column :payrolls, :end, :end_date
  end
end
