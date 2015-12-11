class AddStatusIdToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :status_id, :integer
  end
end
