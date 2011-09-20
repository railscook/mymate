class RenameDeletedAtToHiddenAtInBlogs < ActiveRecord::Migration
  def self.up
   rename_column :blogs, :deleted_at, :hidden_at
  end

  def self.down
   rename_column :blogs, :hidden_at, :deleted_at
  end
end
