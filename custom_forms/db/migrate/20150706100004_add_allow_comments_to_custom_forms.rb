class AddAllowCommentsToCustomForms < ActiveRecord::Migration
  def change
    add_column :custom_forms, :allow_comments, :boolean
  end
end
