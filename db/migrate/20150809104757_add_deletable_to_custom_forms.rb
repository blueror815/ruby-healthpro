class AddDeletableToCustomForms < ActiveRecord::Migration
  def change
    add_column :custom_forms, :deletable, :boolean, default: true
  end
end
