class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string  :name
      t.string  :file
      t.string  :size
      t.string  :content_type
      t.integer :position

      t.timestamps null: false
    end
  end
end
