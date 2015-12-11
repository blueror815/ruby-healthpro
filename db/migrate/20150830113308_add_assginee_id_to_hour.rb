class AddAssgineeIdToHour < ActiveRecord::Migration
  def change
    add_column :hours, :assignee_id, :string
    add_column :hours, :integer, :string
  end
end
