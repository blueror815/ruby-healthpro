class CreateDepartmentsHourTypes < ActiveRecord::Migration
  def change
    create_table :departments_hour_types, id: false do |t|
      t.belongs_to :department, index: true
      t.belongs_to :hour_type, index: true
    end
  end
end
