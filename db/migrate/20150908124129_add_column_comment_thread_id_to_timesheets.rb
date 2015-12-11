class AddColumnCommentThreadIdToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :comment_thread_id, :integer
  end
end
