class CreateJobTypeHourTypes < ActiveRecord::Migration
  def change
    create_table :hour_types_job_types, id: false do |t|
      t.belongs_to :job_type, index: true
      t.belongs_to :hour_type, index: true
    end
  end
end
