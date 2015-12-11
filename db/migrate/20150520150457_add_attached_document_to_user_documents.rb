class AddAttachedDocumentToUserDocuments < ActiveRecord::Migration
  def self.up
    add_attachment :user_documents, :attached_document
  end

  def self.down
    remove_attachment :user_documents, :attached_document
  end
end
