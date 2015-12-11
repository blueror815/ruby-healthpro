class AddCommentThreadColumnToComment < ActiveRecord::Migration
  def change
    add_column :comments, :comment_thread, :integer
  end
end
