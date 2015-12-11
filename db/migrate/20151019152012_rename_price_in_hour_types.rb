class RenamePriceInHourTypes < ActiveRecord::Migration
  def change
    rename_column :hour_types, :price, :price_factor
    change_column :hour_types, :price_factor, 'decimal USING CAST(price_factor AS decimal)'
  end
end
