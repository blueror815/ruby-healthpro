class CreateOnCalls < ActiveRecord::Migration
  def change
    create_table :on_calls do |t|
      t.datetime :date
      t.string :note

      t.timestamps null: false
    end
  end
end
