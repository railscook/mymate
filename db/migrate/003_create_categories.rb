class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
<<<<<<< HEAD
        t.string :title
        t.integer :user_id
        t.boolean :publish
=======

>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
