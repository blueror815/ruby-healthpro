class AddSubmissionDateAndAdmissionDateInPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :submission_date, :datetime
    add_column :payrolls, :admission_date, :datetime
  end
end
