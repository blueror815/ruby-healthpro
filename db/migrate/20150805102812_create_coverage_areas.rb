class CreateCoverageAreas < ActiveRecord::Migration
  def change
    create_table :coverage_areas do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
