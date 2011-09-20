class CreateFooters < ActiveRecord::Migration
  def self.up
    create_table :footers do |t|
      t.text :coding
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :footers
  end
end
