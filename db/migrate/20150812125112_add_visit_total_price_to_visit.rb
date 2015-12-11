class AddVisitTotalPriceToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :visit_total_price, :string
  end
end
