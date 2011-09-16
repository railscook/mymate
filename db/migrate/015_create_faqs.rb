class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.text :question
      t.string :question_type
      t.text :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :faqs
  end
end
