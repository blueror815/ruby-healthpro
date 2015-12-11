class RemoveSectionsFromCustomForms < ActiveRecord::Migration
  def change
    remove_column :custom_forms, :sections, :jsonb
  end
end
