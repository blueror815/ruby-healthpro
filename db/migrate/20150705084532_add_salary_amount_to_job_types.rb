class AddSalaryAmountToJobTypes < ActiveRecord::Migration
  def change
    add_column :job_types, :salary_amount, :decimal
  end
end
