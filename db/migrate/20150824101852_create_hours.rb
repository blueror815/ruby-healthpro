class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.string :progress_state
      t.string :hours
      t.integer :hour_type_id
      t.date :date

      t.timestamps null: false
    end
  end
end
