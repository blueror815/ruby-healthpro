class RemoveMedicalRecordNumberFromVisits < ActiveRecord::Migration
  def change
    remove_column :visits, :medical_record_number
  end
end
