class AddProgressStateToOnCall < ActiveRecord::Migration
  def change
    add_column :on_calls, :progress_state, :string
  end
end
