class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
        t.string :title
        t.text :lyric
        t.string :url
        t.string :description
        t.string :song_type
        t.string :content_type
        t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
