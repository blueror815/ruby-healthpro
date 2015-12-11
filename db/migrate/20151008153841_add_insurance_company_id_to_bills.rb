class AddInsuranceCompanyIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :insurance_company_id, :integer
  end
end
