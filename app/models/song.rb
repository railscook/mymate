class Song < ActiveRecord::Base
	validates_presence_of :title, :message => "can't be blank"
	validates_presence_of :lyric, :message => "can't be blank"
	validates_presence_of :song_type, :message => "can't be blank"
	validates_presence_of :url, :message => "can't be blank"
	validates_format_of :content_type, :with => /^audio/, :message => "! You can only upload songs"	
	belongs_to :user

end
