class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :email
      t.string :contact_number
      t.string :display_name

      t.timestamps null: false
    end
  end
end
