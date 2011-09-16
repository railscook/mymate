class CreateWebpages < ActiveRecord::Migration
  def self.up
    create_table :webpages do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :webpages
  end
end
