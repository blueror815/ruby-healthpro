class CreateLicenseTypes < ActiveRecord::Migration
  def change
    create_table :license_types do |t|
      t.string :name
      t.string :code
      t.integer :job_type_id

      t.timestamps null: false
    end
  end
end
