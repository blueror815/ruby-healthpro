class CreateDepartmentsVisitTypes < ActiveRecord::Migration
  def change
    create_table :departments_visit_types, id: false do |t|
      t.belongs_to :department, index: true
      t.belongs_to :visit_type, index: true
    end
  end
end
