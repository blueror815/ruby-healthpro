class AddNoteToBills < ActiveRecord::Migration
  def change
    add_column :bills, :note, :text
  end
end
