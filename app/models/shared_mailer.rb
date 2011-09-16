class SharedMailer < ActionMailer::Base
  
  @@from       = '"Administrator" <admin@itbaybay.com>'
  @@recipients = [ 'szw1981@gmail.com']
  
  #
  # <tt>:recipient</tt> For url to create new FAQ
  # <tt>:staff</tt> Person sending email
  # <tt>:text</tt> Email text
  
  # Optrions:
  # * <tt>:staff</tt> New staff
  
  def new_account(options = {})
    @from       = @@from 
    @recipients = options[:user].email
    @subject    = "Your account has been created"
    @body       = options
    content_type "text/html"
  end

  def updated_account(options = {})
    @from       = @@from 
    @recipients = options[:user].email
    @subject    = "Your information has been changed"
    @body       = options
    content_type "text/html"
  end
end