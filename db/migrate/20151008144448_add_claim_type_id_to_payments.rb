class AddClaimTypeIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :claim_type_id, :integer
  end
end
