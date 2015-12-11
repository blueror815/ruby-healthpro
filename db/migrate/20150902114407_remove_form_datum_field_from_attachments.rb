class RemoveFormDatumFieldFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :form_datum_field, :string
  end
end
