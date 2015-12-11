class ChangeVisitTotalPriceToTotalPrice < ActiveRecord::Migration
  def change
    rename_column :visits, :visit_total_price, :total_price
  end
end
