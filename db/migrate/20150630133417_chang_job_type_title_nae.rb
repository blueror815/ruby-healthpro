class ChangJobTypeTitleNae < ActiveRecord::Migration
  def change
    rename_column :job_types, :title, :job_class
  end
end
