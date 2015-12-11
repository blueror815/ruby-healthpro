class FixColumnsName < ActiveRecord::Migration
  def change
    rename_column :form_data, :forign_model, :foreign_model
    rename_column :custom_forms, :model_forign_key, :model_foreign_key
  end
end
