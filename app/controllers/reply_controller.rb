class ReplyController < ApplicationController
  def create
    message= File.readlines('/tmp/httplog.txt')
    render :text => "<pre>#{message} </pre>"
  end
end
