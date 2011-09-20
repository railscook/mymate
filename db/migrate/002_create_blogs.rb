class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
        t.string :title
        t.text :body
        t.integer :user_id
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
