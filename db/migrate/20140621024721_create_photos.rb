class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :user
      t.string :caption
      t.timestamps
    end

    add_attachment :photos, :image
  end
end
