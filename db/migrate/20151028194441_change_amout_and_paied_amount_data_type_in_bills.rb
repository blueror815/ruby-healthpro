class ChangeAmoutAndPaiedAmountDataTypeInBills < ActiveRecord::Migration
  def change
    change_column :bills, :amount, :float
    change_column :bills, :paied_amount, :float
  end
end
