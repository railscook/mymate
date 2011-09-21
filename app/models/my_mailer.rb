class MyMailer < ActionMailer::Base
  def receive(message)
    for recipient in message.to
      User.find_by_email(recipient).update_attribute(:bio, message.body)
    end
  end
end

