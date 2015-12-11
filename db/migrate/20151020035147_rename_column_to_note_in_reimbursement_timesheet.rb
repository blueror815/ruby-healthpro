class RenameColumnToNoteInReimbursementTimesheet < ActiveRecord::Migration
  def change
    rename_column :reimbursement_timesheets, :comment, :note
  end
end
