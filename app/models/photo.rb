class Photo < ActiveRecord::Base
		#belongs_to :category line:
	validates_presence_of :url, :message => "can't be blank"
	validates_format_of :content_type, :with => /^image/, :message => "! You can only upload pictures"
	belongs_to :user
	
	def pictureimg=(picture_field)
		return if picture_field.blank?
		self.content_type = picture_field.content_type.chomp
		self.picture = picture_field.read
	end

end
