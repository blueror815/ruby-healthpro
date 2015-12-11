class AddColumnCommentThreadIdToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :comment_thread_id, :integer
  end
end
