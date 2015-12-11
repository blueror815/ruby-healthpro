class FixColumnsName < ActiveRecord::Migration
  def change
    rename_column :custom_forms, :forign_model, :foreign_model
    rename_column :form_data, :model_forign_key, :model_foreign_key
  end
end
