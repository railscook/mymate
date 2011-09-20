class CreateFileclassifieds < ActiveRecord::Migration
  def self.up
    create_table :fileclassifieds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fileclassifieds
  end
end
