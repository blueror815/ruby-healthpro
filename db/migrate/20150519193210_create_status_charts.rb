class CreateStatusCharts < ActiveRecord::Migration
  def change
    create_table :status_charts do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
