class CreateBonuses < ActiveRecord::Migration
  def change
    create_table :bonuses do |t|
      t.integer :user_id
      t.string :price
      t.integer :timesheet_id

      t.timestamps null: false
    end
  end
end
