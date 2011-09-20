class CreateWebpages < ActiveRecord::Migration
  def self.up
    create_table :webpages do |t|
<<<<<<< HEAD
        t.string :description
        t.string :file_name
        t.text :text
        t.boolean :publish
        t.string :url
        t.string :content_type
        t.integer :category_id
=======

>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6
      t.timestamps
    end
  end

  def self.down
    drop_table :webpages
  end
end
