class RemoveColumnCommentThreadIdFromVisits < ActiveRecord::Migration
  def change
    remove_column :visits, :comment_thread_id, :integer if column_exists?(:visits, :comment_thread_id)
  end
end
