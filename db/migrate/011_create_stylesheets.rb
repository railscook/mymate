class CreateStylesheets < ActiveRecord::Migration
  def self.up
    create_table :stylesheets do |t|
        t.string :name
        t.text :css
        t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stylesheets
  end
end
