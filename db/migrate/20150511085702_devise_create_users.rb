class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      # custom data
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :username
      t.string :title
      t.string :caregiver_code
      t.string :code
      t.string :address
      t.string :address2
      t.string :home_phone
      t.string :cell_phone
      t.string :office_phone
      t.string :fax
      t.string :color
      t.string :agency
      t.string :agency_short
      t.string :zipcode
      t.string :social_security
      t.string :emergency_contact_name
      t.string :emergency_phone
      t.string :emergency_alternate_phone
      t.string :user_type
      t.string :user_type_short
      t.string :additional_user_types
      t.string :employment_type
      t.string :state
      t.string :city
      t.boolean :status, default: true
      t.boolean :on_call, default: false
      t.datetime :hire_date
      t.datetime :birth_date
      t.attachment :image

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
