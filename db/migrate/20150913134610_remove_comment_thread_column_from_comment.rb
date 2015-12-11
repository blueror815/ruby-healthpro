class RemoveCommentThreadColumnFromComment < ActiveRecord::Migration
  def change
    remove_column :comments, :comment_thread_id, :integer if column_exists?(:comments, :comment_thread_id)
  end
end
