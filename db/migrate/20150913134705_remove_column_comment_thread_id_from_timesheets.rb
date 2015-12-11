class RemoveColumnCommentThreadIdFromTimesheets < ActiveRecord::Migration
  def change
    remove_column :timesheets, :comment_thread_id, :integer if column_exists?(:timesheets, :comment_thread_id)
  end
end
