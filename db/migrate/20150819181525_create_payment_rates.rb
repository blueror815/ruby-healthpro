class CreatePaymentRates < ActiveRecord::Migration
  def change
    create_table :payment_rates do |t|
      t.belongs_to :user, index: true
      t.belongs_to :visit_type, index: true
      t.integer :payment_method_id
      t.decimal :price

      t.timestamps null: false
    end
  end
end
