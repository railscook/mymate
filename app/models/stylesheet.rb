class Stylesheet < ActiveRecord::Base
	validates_presence_of :name, :message => "can't be blank"
	validates_presence_of :css, :message => "can't be blank"
	belongs_to :user
end
