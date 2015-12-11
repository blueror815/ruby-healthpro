class AddProgressStateToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :progress_state, :string
  end
end
