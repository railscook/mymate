class CreateNewFile < ActiveRecord::Base
	validates_presence_of :file_name, :message => "can't be blank"	
	validates_presence_of :description, :message => "can't be blank"	
	validates_presence_of :text, :message => "can't be blank"
	validates_presence_of :url, :message => "can't be blank"	
	#validates_format_of :content_type, :with => /^text/, :message => "You can only upload html files"
	belongs_to :content
end
