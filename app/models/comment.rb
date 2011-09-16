class Comment < ActiveRecord::Base
	#validates_presence_of :attribute, :on => :create, :message => "can't be blank"
	validates_presence_of :body, :message => "can't be blank"
	validates_presence_of :user_name, :message => "can't be blank"
	validates_presence_of :email, :message => "can't be blank"
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,  :message => "Fill your real email address"
	belongs_to :blog
end
