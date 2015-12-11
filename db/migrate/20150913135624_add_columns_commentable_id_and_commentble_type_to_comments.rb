class AddColumnsCommentableIdAndCommentbleTypeToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_id, :integer unless column_exists?(:comments, :commentable_id)
    add_column :comments, :commentable_type, :string unless column_exists?(:comments, :commentable_type)
  end
end
