class AddVisitIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :visit_id, :integer
  end
end
