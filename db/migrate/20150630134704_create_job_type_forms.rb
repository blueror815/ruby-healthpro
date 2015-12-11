class CreateJobTypeForms < ActiveRecord::Migration
  def change
    create_table :job_type_forms do |t|
      t.integer :job_type_id
      t.integer :custom_form_id

      t.timestamps null: false
    end
  end
end
