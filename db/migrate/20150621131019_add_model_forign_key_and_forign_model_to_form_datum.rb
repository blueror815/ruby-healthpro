class AddModelForignKeyAndForignModelToFormDatum < ActiveRecord::Migration
  def change
    add_column :form_data, :model_forign_key, :integer
  end
end
