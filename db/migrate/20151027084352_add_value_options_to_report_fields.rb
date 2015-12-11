class AddValueOptionsToReportFields < ActiveRecord::Migration
  def change
    add_column :report_fields, :value_options, :jsonb
  end
end
