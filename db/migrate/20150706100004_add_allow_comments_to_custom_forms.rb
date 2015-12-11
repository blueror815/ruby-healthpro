# This migration comes from custom_forms (originally 20150706100004)
class AddAllowCommentsToCustomForms < ActiveRecord::Migration
  def change
    add_column :custom_forms, :allow_comments, :boolean
  end
end
