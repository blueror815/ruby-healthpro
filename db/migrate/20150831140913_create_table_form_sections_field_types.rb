class CreateTableFormSectionsFieldTypes < ActiveRecord::Migration
  def change
    create_table :form_sections_field_types do |t|
      t.belongs_to :field_type
      t.belongs_to :form_section
      t.integer :order
      t.boolean :index_display, default: false
      t.boolean :required, default: false
      t.index [:field_type_id, :form_section_id], name: 'field_type_id_form_section_id'
      t.index [:form_section_id, :field_type_id], name: 'form_section_id_field_type_id'

      t.timestamps null: false
    end
  end
end
