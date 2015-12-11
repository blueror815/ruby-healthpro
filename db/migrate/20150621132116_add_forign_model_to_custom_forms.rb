class AddForignModelToCustomForms < ActiveRecord::Migration
  def change
    add_column :custom_forms, :forign_model, :string
  end
end
