class AddSocDateAndDischargedDateToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :soc_date, :date
    add_column :patients, :discharged_date, :date
  end
end
