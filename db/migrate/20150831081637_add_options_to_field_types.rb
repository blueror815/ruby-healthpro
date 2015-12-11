class AddOptionsToFieldTypes < ActiveRecord::Migration
  def change
    add_column :field_types, :options, :jsonb
  end
end
