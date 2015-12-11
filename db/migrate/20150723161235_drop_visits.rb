class DropVisits < ActiveRecord::Migration
  def change
    drop_table :visits if table_exists?(:visits)
  end
end
