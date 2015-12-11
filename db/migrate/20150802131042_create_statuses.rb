class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :title
      t.integer :devero_id

      t.timestamps null: false
    end
  end
end
