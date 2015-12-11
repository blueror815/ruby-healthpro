class AddMedicalRecordNumberAndInsuranceIdAndStatusChartIdToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :medical_record_number, :string
    add_column :patients, :insurance_id, :integer
    add_column :patients, :status_chart_id, :integer
  end
end
