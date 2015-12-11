class CreateFormSections < ActiveRecord::Migration
  def change
    create_table :form_sections do |t|
      t.string :title
      t.jsonb :permissions
      t.belongs_to :custom_form, index: true

      t.timestamps null: false
    end
  end
end
