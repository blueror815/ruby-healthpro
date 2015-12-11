class AddFromAndToColumnsToHours < ActiveRecord::Migration
  def change
    add_column :hours, :from, :time
    add_column :hours, :to, :time
  end
end
