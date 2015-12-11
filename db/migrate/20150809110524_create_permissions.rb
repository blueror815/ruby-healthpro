class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :action_name
      t.string :object_type
      t.jsonb :conditions
      t.index [:action_name, :object_type], :unique => true

      t.timestamps null: false
    end
  end
end
