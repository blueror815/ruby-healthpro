class ChangePaiedAmountDefaultValueInBills < ActiveRecord::Migration
  def change
    change_column_default :bills, :paied_amount, 0
  end
end
