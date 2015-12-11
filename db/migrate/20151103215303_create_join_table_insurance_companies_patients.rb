class CreateJoinTableInsuranceCompaniesPatients < ActiveRecord::Migration
  def change
    create_join_table :insurance_companies, :patients do |t|
      t.index [:insurance_company_id, :patient_id], name: 'insurance_company_id_patient_id'
      t.index [:patient_id, :insurance_company_id], name: 'patient_id_insurance_company_id'
    end
  end
end
