class MailsController < ApplicationController

  def index
	@mails = Mail.find(:all)
  end
end
