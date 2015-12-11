class AddExpirationDateToUserDocuments < ActiveRecord::Migration
  def change
    add_column :user_documents, :expiration_date, :date
  end
end
