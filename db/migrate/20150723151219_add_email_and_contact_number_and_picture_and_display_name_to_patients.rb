class AddEmailAndContactNumberAndPictureAndDisplayNameToPatients < ActiveRecord::Migration
  def change
    change_table :patients do |t|
      t.attachment :image
    end
  end
end
