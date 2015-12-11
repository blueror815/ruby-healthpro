class CreateInsuranceCompanies < ActiveRecord::Migration
  def change
    create_table :insurance_companies do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
