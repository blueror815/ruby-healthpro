class AddRowOrderToFormData < ActiveRecord::Migration
  def change
    add_column :form_data, :row_order, :integer
  end
end
