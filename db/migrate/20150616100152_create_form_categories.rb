class CreateFormCategories < ActiveRecord::Migration
  def change
    create_table :form_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
