class AddClaimStartDateAndClaimEndDateToBills < ActiveRecord::Migration
  def change
    add_column :bills, :claim_start_date, :date
    add_column :bills, :claim_end_date, :date
  end
end
