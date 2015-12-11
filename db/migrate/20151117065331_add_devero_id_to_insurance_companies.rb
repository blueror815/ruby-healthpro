class AddDeveroIdToInsuranceCompanies < ActiveRecord::Migration
  def change
    add_column :insurance_companies, :devero_id, :string
  end
end
