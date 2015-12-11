class CreateJobTypes < ActiveRecord::Migration
  def change
    create_table :job_types do |t|
      t.string :title
      t.string :user_type
      t.string :short_user_type

      t.timestamps null: false
    end
  end
end
