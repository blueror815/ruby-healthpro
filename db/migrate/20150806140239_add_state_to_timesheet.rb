class AddStateToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :state, :integer, default: 1
  end
end
