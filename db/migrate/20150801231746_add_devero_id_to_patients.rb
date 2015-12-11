class AddDeveroIdToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :devero_id, :integer
  end
end
