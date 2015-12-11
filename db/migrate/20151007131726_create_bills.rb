class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.date :date
      t.date :payment_date
      t.decimal :amount
      t.decimal :paied_amount
      t.integer :patient_id

      t.timestamps null: false
    end
  end
end
