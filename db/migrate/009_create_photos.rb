class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
        t.string :picture_name
        t.string :url
        t.string :content_type
        t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
