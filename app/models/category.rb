class Category < ActiveRecord::Base
  validates_presence_of :title, :message => "can't be blank"	
  #validates_uniqueness_of :title, :if => proc { |user| session[:user].id? }
  	has_many :webpages, :dependent => :nullify  
 	belongs_to :user	
end

