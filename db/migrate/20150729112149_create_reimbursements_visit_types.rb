class CreateReimbursementsVisitTypes < ActiveRecord::Migration
  def change
    create_table :reimbursements_visit_types do |t|
      t.belongs_to :reimbursement, index: true
      t.belongs_to :visit_type, index: true
    end
  end
end
