class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :custom_form_id
      t.string :name

      t.timestamps null: false
    end
  end
end
