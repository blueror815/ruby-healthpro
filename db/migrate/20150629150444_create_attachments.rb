class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.attachment :file
      t.integer :form_datum_id
      t.string :form_datum_field

      t.timestamps null: false
    end
  end
end
