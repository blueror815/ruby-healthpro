class AddBillIdToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :bill_id, :integer
  end
end
