class AddClaimTypeIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :claim_type_id, :integer
  end
end
