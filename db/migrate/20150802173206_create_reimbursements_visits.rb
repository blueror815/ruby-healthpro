class CreateReimbursementsVisits < ActiveRecord::Migration
  def change
    create_table :reimbursements_visits do |t|
      t.belongs_to :reimbursement, index: true
      t.belongs_to :visit, index: true
    end
  end
end
