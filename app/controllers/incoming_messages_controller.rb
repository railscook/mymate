class IncomingMessagesController < ApplicationController
  def create
    message = params[:message]
    msg = message.split("\r\n")
    if msg.size > 1
    	 /<([a-z0-9.@]+)>/ =~ msg[1]
     	to = $1
     	/<([a-z0-9.@]+)>/ =~ msg[4]
	from = $1
	/Subject: ([a-zA-Z0-9\s]+)/ =~ msg[9]
	subject = $1
     message = {:to => to, :from => from, :subject => subject, :body => msg[19..msg.size]}
    end    

    if message.is_a?(Hash)
    mail = Mail.new(message) 
    message = mail.subject if mail.respond_to?(:subject)
    mail.save
    end

    File.open("#{RAILS_ROOT}/log/messages", "r+") do |f|
	f.write(params[:message].inspect)
    end
    render :text => message
  end
end
