class AddExtraDataColumnToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :zipcode, :string
    add_column :patients, :street, :string
    add_column :patients, :city, :string
    add_column :patients, :state, :string
    add_column :patients, :apartment_number, :string
    add_column :patients, :phone, :string
    add_column :patients, :emergency_contact, :string
    add_column :patients, :emergency_contact_phone, :string
  end
end
