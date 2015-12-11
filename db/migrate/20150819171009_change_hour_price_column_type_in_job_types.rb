class ChangeHourPriceColumnTypeInJobTypes < ActiveRecord::Migration
  def up
    remove_column :job_types, :hour_price
    add_column :job_types, :hour_price, :decimal
  end

  def down
    add_column :job_types, :hour_price
    remove_column :job_types, :hour_price, :decimal
  end
end
