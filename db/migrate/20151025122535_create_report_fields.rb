class CreateReportFields < ActiveRecord::Migration
  def change
    create_table :report_fields do |t|
      t.string :field_type
      t.integer :report_id
      t.string :field_value

      t.timestamps null: false
    end
  end
end
