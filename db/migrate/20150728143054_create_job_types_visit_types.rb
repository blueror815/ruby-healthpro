class CreateJobTypesVisitTypes < ActiveRecord::Migration
  def change
    create_table :job_types_visit_types do |t|
      t.integer :job_type_id
      t.integer :visit_type_id

      t.timestamps null: false
    end
  end
end
