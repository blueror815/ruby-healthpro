class AddMonthlyPaidToClaimType < ActiveRecord::Migration
  def change
    add_column :claim_types, :monthly_paid, :boolean
  end
end
