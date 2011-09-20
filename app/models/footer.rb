class Footer < ActiveRecord::Base
	validates_presence_of :coding, :message => "can't be blank"
	belongs_to :user
end
