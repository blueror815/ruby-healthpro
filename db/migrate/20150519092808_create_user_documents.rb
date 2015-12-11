class CreateUserDocuments < ActiveRecord::Migration
  def change
    create_table :user_documents do |t|
      t.integer :user_id
      t.integer :document_type_id

      t.timestamps null: false
    end
  end
end
