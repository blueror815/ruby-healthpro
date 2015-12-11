class AddActionCountAndCommentToVisitReimbursement < ActiveRecord::Migration
  def change
    add_column :reimbursements_visits, :action_count, :integer
    add_column :reimbursements_visits, :comment, :string
  end
end
