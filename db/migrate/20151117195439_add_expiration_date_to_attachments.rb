class AddExpirationDateToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :expiration_date, :date
  end
end
