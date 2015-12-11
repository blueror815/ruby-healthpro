class RemveColumnNotifiableIdFromCommentThread < ActiveRecord::Migration
  def change
    remove_column :comment_threads, :notifiable_id
  end
end
