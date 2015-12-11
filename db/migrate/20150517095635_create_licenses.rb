class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name
      t.date :start_date
      t.date :expiration_date
      t.boolean :expired
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
