# This migration comes from custom_forms (originally 20150609064428)
class CreateFormData < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'form_data'
      create_table :form_data do |t|
        t.integer :custom_form_id
        t.jsonb :sections_data

        t.timestamps null: false
      end
    end
  end
end
