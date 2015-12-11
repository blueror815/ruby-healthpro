class RemoveHourTypeIdFormPaymentRates < ActiveRecord::Migration
  def change
    remove_column :payment_rates, :hour_type_id, :integer
  end
end
