class RefactorComments < ActiveRecord::Migration
  def change
  	remove_column :comments, :visit_id
  	remove_column :comments, :form_datum_id
  	add_column :comments, :commentable_id, :integer
  end
end
