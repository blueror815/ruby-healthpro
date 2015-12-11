# This migration comes from custom_forms (originally 20150531171403)
class CreateCustomForms < ActiveRecord::Migration
  def change
    create_table :custom_forms do |t|
      t.string :title
      t.jsonb :permissions
      t.jsonb :sections

      t.timestamps null: false
    end
  end
end
