class AddFieldAliasesToReportFields < ActiveRecord::Migration
  def change
    add_column :report_fields, :field_aliases, :text, array: true, default: []
  end
end
