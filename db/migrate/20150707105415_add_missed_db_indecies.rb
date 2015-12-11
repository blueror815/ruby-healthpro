class AddMissedDbIndecies < ActiveRecord::Migration
  def change
    add_index :custom_forms, :form_category_id
    add_index :attachments, :form_datum_id
    # add_index :comments, :user_id
    # add_index :comments, :form_datum_id
    add_index :document_types, :job_type_id
    add_index :form_data, :custom_form_id
    add_index :form_data, :user_id
    add_index :job_type_forms, :job_type_id
    add_index :license_types, :job_type_id
    add_index :licenses, :user_id
    add_index :timesheets, :user_id
    add_index :timesheets, :payroll_id
    add_index :user_documents, :user_id
    add_index :user_documents, :document_type_id
    add_index :users, :job_type_id
    add_index :users, :role_id
    # add_index :visits, :user_id
    # add_index :visits, :patient_id
  end
end
