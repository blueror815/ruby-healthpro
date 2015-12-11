class RemoveUselessAttributesFormUsers < ActiveRecord::Migration
  def change
    remove_column :users, :first_name
    remove_column :users, :middle_name
    remove_column :users, :last_name
    remove_column :users, :username
    remove_column :users, :title
    remove_column :users, :caregiver_code
    remove_column :users, :code
    remove_column :users, :address
    remove_column :users, :address2
    remove_column :users, :home_phone
    remove_column :users, :cell_phone
    remove_column :users, :office_phone
    remove_column :users, :fax
    remove_column :users, :color
    remove_column :users, :agency
    remove_column :users, :agency_short
    remove_column :users, :zipcode
    remove_column :users, :social_security
    remove_column :users, :emergency_contact_name
    remove_column :users, :emergency_phone
    remove_column :users, :emergency_alternate_phone
    remove_column :users, :user_type
    remove_column :users, :user_type_short
    remove_column :users, :additional_user_types
    remove_column :users, :employment_type
    remove_column :users, :state
    remove_column :users, :city
    remove_column :users, :status, default: true
    remove_column :users, :on_call, default: false
    remove_column :users, :hire_date
    remove_column :users, :birth_date
  end
end
