class Contact < ActiveRecord::Base
	validates_presence_of :name, :message => "can't be blank"
	validates_presence_of :email, :message => "can't be blank"
	validates_presence_of :phone,  :message => "can't be blank"
	validates_presence_of :address_line1, :message => "can't be blank"
	validates_presence_of :city, :message => "can't be blank"
	validates_presence_of :state_county,  :message => "can't be blank"
	validates_presence_of :postal_code, :message => "can't be blank"
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :message => " should be correct email address." 

	belongs_to :user
end
