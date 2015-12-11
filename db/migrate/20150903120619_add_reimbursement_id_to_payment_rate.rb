class AddReimbursementIdToPaymentRate < ActiveRecord::Migration
  def change
    add_column :payment_rates, :reimbursement_id, :integer
  end
end
