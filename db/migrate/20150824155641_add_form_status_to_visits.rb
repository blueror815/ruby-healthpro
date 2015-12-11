class AddFormStatusToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :form_status, :string
  end
end
