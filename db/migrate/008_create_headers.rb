class CreateHeaders < ActiveRecord::Migration
  def self.up
    create_table :headers do |t|
        t.text :coding
        t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :headers
  end
end
