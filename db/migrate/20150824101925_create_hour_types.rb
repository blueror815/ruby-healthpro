class CreateHourTypes < ActiveRecord::Migration
  def change
    create_table :hour_types do |t|
      t.string :title
      t.string :price

      t.timestamps null: false
    end
  end
end
