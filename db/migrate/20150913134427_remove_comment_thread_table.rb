class RemoveCommentThreadTable < ActiveRecord::Migration
  def change
    drop_table :comment_threads if table_exists?(:comment_threads)
  end
end
