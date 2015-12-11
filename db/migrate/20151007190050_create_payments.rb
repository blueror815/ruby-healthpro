class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :date
      t.decimal :amount
      t.string :notes
      t.integer :patient_id

      t.timestamps null: false
    end
  end
end
