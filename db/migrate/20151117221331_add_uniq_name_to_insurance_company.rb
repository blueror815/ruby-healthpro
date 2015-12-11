class AddUniqNameToInsuranceCompany < ActiveRecord::Migration
  def change
    add_column :insurance_companies, :uniq_name, :string
  end
end
