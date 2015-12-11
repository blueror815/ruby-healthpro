class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :total_price
      t.integer :payable_id
      t.string :payable_type
      t.integer :timesheet_id

      t.timestamps null: false
    end
  end
end
