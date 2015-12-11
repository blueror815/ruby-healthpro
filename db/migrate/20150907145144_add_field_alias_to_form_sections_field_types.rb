class AddFieldAliasToFormSectionsFieldTypes < ActiveRecord::Migration
  def change
    add_column :form_sections_field_types, :field_alias, :string
  end
end
