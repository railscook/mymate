require 'digest/sha1'
class User < ActiveRecord::Base

	validates_presence_of :title, :fname, :lname, :gender, :email, :login, :password, :message => "can't be blank"	
	
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :message => " should be correct email address." 
	
	validates_confirmation_of :email 
	validates_uniqueness_of :login , :email 
  
  has_many :categories
  has_many :blogs
  has_many :photos
  has_many :contacts
  has_many :fileclassifieds
  has_many :songs
  has_many :videos
  has_many :headers
  has_many :footers
  
  
  def password=(value) 
    write_attribute("password", Digest::SHA1.hexdigest(value)) 
  end 
  
  def self.authenticate(login,password) 
    find(:first, :conditions => ["login = ? and password = ?",login, Digest::SHA1.hexdigest(password)]) 
  end 
  
end
