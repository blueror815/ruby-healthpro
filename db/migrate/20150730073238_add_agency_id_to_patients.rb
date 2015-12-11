class AddAgencyIdToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :agency_id, :integer
  end
end
