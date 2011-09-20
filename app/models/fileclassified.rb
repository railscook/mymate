class Fileclassified < ActiveRecord::Base
	validates_presence_of :url, :message => "can't be blank"
	belongs_to :user
	def filesrc=(file_field)
		return if file_field.blank?
		self.content_type = file_field.content_type.chomp
		self.file = file_field.read
	end
	
	  def self.save(fileclassified)
	  	
	  	@filename = fileclassified['url'].original_filename
	  	person['picture'].rewind
	    File.open("pictures/#{fileclassified['name']}/"+@filename+".jpg", "wb") { |f| 
	    f.write(fileclassified['url'].read) }
  	end

	private
    def sanitize_filename(value)
        # get only the filename, not the whole path
        just_filename = value.gsub(/^.*(\\|\/)/, '')
        # NOTE: File.basename doesn't work right with Windows paths on Unix
        # INCORRECT: just_filename = File.basename(value.gsub('\\\\', '/')) 

        # Finally, replace all non alphanumeric, underscore or periods with underscore
        @filename = just_filename.gsub(/[^\w\.\-]/,'_') 
    end
end
