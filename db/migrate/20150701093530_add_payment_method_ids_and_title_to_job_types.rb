class AddPaymentMethodIdsAndTitleToJobTypes < ActiveRecord::Migration
  def change
    add_column :job_types, :title, :text
    add_column :job_types, :payment_method_ids, :text, array: true, default: []
  end
end
