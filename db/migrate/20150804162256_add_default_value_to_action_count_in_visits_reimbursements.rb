class AddDefaultValueToActionCountInVisitsReimbursements < ActiveRecord::Migration
  def change
    change_column :reimbursements_visits, :action_count, :integer, default: 1
  end
end
