class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :phone
      t.string :fax
      t.string :zipcode
      t.string :state
      t.string :city
      t.integer :devero_id
      t.string :display_name
      t.string :short_name
      t.string :address
      t.string :address2
      t.string :email
      t.string :name
      t.string :medicare_provider_number
      t.integer :hha_agency_id
      t.integer :branch_id
      t.string :rate
      t.string :fax_service_username
      t.string :fax_service_password
      t.integer :fax_service_account_id
      t.string :timezone

      t.timestamps null: false
    end
  end
end
