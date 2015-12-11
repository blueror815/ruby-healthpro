class ChangePriceTypeInVisitType < ActiveRecord::Migration
  def change
    change_column :visit_types, :price, 'decimal using cast(price as integer)'
  end
end
