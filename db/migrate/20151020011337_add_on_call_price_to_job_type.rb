class AddOnCallPriceToJobType < ActiveRecord::Migration
  def change
    add_column :job_types, :on_call_price, :string
  end
end
