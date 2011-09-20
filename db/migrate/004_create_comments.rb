class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
<<<<<<< HEAD
        t.text :body
        t.string :user_name
        t.string :email
        t.integer :blog_id
=======

>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
