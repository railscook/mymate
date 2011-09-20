class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
<<<<<<< HEAD
      t.string :login
        t.string :password
=======

>>>>>>> 04b21e7546803758ad77c4ea602795c589a2ffc6
      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
