class CreateAdminConfigurations < ActiveRecord::Migration
  def change
    create_table :admin_configurations do |t|
      t.string :title
      t.jsonb :configurations

      t.timestamps null: false
    end
  end
end
