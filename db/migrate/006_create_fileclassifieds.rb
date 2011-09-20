class CreateFileclassifieds < ActiveRecord::Migration
  def self.up
    create_table :fileclassifieds do |t|
<<<<<<< HEAD
        t.string :name
        t.string :url
        t.string :content_type
        t.integer :user_id

=======
>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6

      t.timestamps
    end
  end

  def self.down
    drop_table :fileclassifieds
  end
end
