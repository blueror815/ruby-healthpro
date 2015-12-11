class AddUserIdToReimbursementTimesheet < ActiveRecord::Migration
  def change
    add_column :reimbursement_timesheets, :user_id, :integer
  end
end
