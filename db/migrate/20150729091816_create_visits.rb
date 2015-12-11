class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :medical_record_number
      t.string :progress_state
      t.string :billing_state
      t.string :billing_code
      t.date :date
      t.time :time_in
      t.time :time_out
      t.integer :agency_id
      t.integer :assigner_id
      t.integer :assignee_id
      t.integer :patient_id
      t.integer :visit_type_id

      t.timestamps null: false
    end
  end
end
