class AddDeletedAtToBlogs < ActiveRecord::Migration
  def self.up
   add_column :blogs, :deleted_at, :datetime
  end

  def self.down
   remove_column :blogs, :deleted_at
  end
end
