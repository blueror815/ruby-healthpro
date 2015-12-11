# This migration comes from custom_forms (originally 20150706100554)
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :form_datum_id
      t.text :content

      t.timestamps null: false
    end
  end
end
