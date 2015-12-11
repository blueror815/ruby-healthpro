class CreateReimbursements < ActiveRecord::Migration
  def change
    create_table :reimbursements do |t|
      t.string :title
      t.integer :value_type
      t.decimal :price

      t.timestamps null: false
    end
  end
end
