class NotificationMailer < ApplicationMailer
  def new_user(user)
    @user = user
    mail to: user.email
  end

  def send_words(user, user_words)
    @user = user
    @user_words = user_words
    mail to: user.email, subject: 'Words for learning'
  end
end
