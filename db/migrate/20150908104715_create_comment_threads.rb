class CreateCommentThreads < ActiveRecord::Migration
  def change
    create_table :comment_threads do |t|
      t.integer :notifiable_id

      t.timestamps null: false
    end
  end
end
