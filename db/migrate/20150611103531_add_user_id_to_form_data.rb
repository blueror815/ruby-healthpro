class AddUserIdToFormData < ActiveRecord::Migration
  def change
    add_column :form_data, :user_id, :integer unless CustomForms::FormDatum.column_names.include?('user_id')
  end
end
