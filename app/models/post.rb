class Post < ActiveRecord::Base
	validates_presence_of :title, :on => :create, :message => "can't be blank"
	validates_presence_of :body, :on => :create, :message => "can't be blank"
	has_many :comments
	#belongs_to :content
	belongs_to :user
end
