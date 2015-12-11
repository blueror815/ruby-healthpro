class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.date :start
      t.date :end

      t.timestamps null: false
    end
  end
end
