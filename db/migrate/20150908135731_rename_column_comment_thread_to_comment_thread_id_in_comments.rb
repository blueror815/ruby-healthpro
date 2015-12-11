class RenameColumnCommentThreadToCommentThreadIdInComments < ActiveRecord::Migration
  def change
    rename_column :comments, :comment_thread, :comment_thread_id
  end
end
