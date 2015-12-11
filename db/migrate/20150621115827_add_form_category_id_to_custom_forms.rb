class AddFormCategoryIdToCustomForms < ActiveRecord::Migration
  def change
    add_column :custom_forms, :form_category_id, :integer
  end
end
