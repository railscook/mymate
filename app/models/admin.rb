class Admin < ActiveRecord::Base
  validates_presence_of :login, :message => "can't be blank"
  validates_presence_of :password, :message => "can't be blank"
  validates_uniqueness_of :login, :on => :create, :message => "must be unique"

  def password=(value) 
    write_attribute("password", value) 
  end 
  
  def self.authenticate(login,password) 
    find(:first, :conditions => ["login = ? and password = ?", login, password]) 
  end 

end
