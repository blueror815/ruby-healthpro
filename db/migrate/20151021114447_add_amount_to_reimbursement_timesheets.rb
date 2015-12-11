class AddAmountToReimbursementTimesheets < ActiveRecord::Migration
  def change
    add_column :reimbursement_timesheets, :amount, :decimal
  end
end
