class AddInsuranceCompanyIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :insurance_company_id, :integer
  end
end
