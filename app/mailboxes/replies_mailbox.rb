class RepliesMailbox < ApplicationMailbox
  MATCHER = /reply-(.+)@reply.example.com/i
  #mail
  #inbound_email => ActionMailBox::INboundEmail record  
  before_processing :ensure_user
  def process
     return unless user.present?
     message.comments.create(
       user: user,
       body: mail.decode
     )
  end
  def user
     @user ||= User.find_by(email.from)
  end 
  def message
     @message ||= Message.find(message_id)
  end 
  
  def message
    recipient = mail.recipients.find{ |r| MATCHER.match?(r)}
    recipient[MATCHER, 1]
  end

  def ensure_user
    if user.nil?
       bounce_with UserMailer.missing(inbound_email) 
    end 
  end  
end
