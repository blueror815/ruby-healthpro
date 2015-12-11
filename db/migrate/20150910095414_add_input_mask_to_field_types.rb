class AddInputMaskToFieldTypes < ActiveRecord::Migration
  def change
    add_column :field_types, :input_mask, :string
  end
end
