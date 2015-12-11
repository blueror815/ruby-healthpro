class ChangeReimbursementDefaultActionCount < ActiveRecord::Migration
  def change
    change_column_default :reimbursements_visits, :action_count, 0
  end
end
