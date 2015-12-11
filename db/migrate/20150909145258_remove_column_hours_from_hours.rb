class RemoveColumnHoursFromHours < ActiveRecord::Migration
  def change
    remove_column :hours, :hours, :string
  end
end
