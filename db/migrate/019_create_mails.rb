class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.string :status
      t.string :cloudmailin_id
      t.string :to
      t.string :from
      t.string :subject
      t.datetime :date
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end
