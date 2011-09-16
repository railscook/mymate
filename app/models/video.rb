class Video < ActiveRecord::Base
	validates_presence_of :title, :message => "can't be blank"
	validates_presence_of :description, :message => "can't be blank"
	validates_presence_of :video_type, :message => "can't be blank"
	validates_presence_of :url, :message => "can't be blank"
	validates_format_of :content_type, :with => /^video/, :message => "! You can only upload videos"
	belongs_to :user
end
