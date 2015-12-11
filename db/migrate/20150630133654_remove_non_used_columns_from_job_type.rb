class RemoveNonUsedColumnsFromJobType < ActiveRecord::Migration
  def change
    remove_column :job_types, :user_type
    remove_column :job_types, :short_user_type
  end
end
