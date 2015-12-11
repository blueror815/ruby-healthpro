class AddHourPriceToJobTypes < ActiveRecord::Migration
  def change
    add_column :job_types, :hour_price, :jsonb
  end
end
