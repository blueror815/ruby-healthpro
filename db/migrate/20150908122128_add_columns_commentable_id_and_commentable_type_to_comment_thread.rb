class AddColumnsCommentableIdAndCommentableTypeToCommentThread < ActiveRecord::Migration
  def change
    add_column :comment_threads, :commentable_type, :string
    add_column :comment_threads, :commentable_id, :integer
  end
end
