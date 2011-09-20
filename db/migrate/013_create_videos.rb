class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
<<<<<<< HEAD
        t.string :title
        t.string :url
        t.string :description
        t.string :video_type
        t.string :content_type
        t.integer :user_id
=======

>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
