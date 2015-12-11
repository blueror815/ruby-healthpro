class SetDefaultColumnsValuesInJobTypes < ActiveRecord::Migration
  def change
    change_column :job_types, :hour_price, :decimal, default: 0.0
    change_column :job_types, :salary_amount, :decimal, default: 0.0
  end
end
