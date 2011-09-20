class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
<<<<<<< HEAD
        t.string :title
        t.text :body
        t.integer :user_id
      t.datetime :deleted_at
=======

>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
