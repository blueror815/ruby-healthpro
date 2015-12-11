class AddHourTypeIdToPaymentRate < ActiveRecord::Migration
  def change
    add_column :payment_rates, :hour_type_id, :integer
  end
end
