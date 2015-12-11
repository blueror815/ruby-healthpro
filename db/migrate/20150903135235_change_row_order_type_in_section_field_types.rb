class ChangeRowOrderTypeInSectionFieldTypes < ActiveRecord::Migration
  def change
    change_column :form_sections_field_types, :row_order, :integer, :null => false, :default => 0
  end
end
