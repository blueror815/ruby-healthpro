class CreateFormData < ActiveRecord::Migration
  def change
    create_table :form_data do |t|
      t.integer :custom_form_id
      t.jsonb :sections_data

      t.timestamps null: false
    end
  end
end
