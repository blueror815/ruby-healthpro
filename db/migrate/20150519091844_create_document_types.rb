class CreateDocumentTypes < ActiveRecord::Migration
  def change
    create_table :document_types do |t|
      t.string :document_name
      t.integer :job_type_id

      t.timestamps null: false
    end
  end
end
