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
