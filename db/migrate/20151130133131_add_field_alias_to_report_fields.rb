class AddFieldAliasToReportFields < ActiveRecord::Migration
  def change
    add_column :report_fields, :field_alias, :string
  end
end
