class AddCreatorUserIdToFormData < ActiveRecord::Migration
  def change
    add_column :form_data, :creator_user_id, :integer
  end
end
