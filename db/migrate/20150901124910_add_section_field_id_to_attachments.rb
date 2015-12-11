class AddSectionFieldIdToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :section_field_id, :integer
  end
end
