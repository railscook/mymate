class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.string :title
        t.string :fname
        t.string :lname
        t.string :gender
        t.date :dob
        t.string :email
        t.string :login
        t.string :password
        t.string :country
        t.string :pw
        t.integer :stylesheet_id
     t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
