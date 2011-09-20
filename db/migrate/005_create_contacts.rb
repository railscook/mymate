class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
        t.string :name
        t.string :email
        t.string :phone
        t.string :address_line1
        t.string :address_line2
        t.string :city
        t.string :state_county
        t.string :country
        t.string :postal_code
        t.string :hometown
        t.string :college
        t.string :school
        t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
