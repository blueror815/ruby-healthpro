class AddPatientIdToFormData < ActiveRecord::Migration
  def change
    add_column :form_data, :patient_id, :integer
  end
end
