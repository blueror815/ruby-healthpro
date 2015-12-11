class CreateJoinTableFiledTypesReportFields < ActiveRecord::Migration
  def change
    create_join_table :field_types, :report_fields do |t|
      t.index [:field_type_id, :report_field_id], name: 'field_type_id_report_field_id'
      t.index [:report_field_id, :field_type_id], name: 'report_field_id_field_type_id'
    end
  end
end
