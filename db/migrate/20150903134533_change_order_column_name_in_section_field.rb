class ChangeOrderColumnNameInSectionField < ActiveRecord::Migration
  def change
    rename_column :form_sections_field_types, :order, :row_order
  end
end
