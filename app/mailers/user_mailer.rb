class UserMailer < ActionMailer::Base
  default from: "admin@realifex.com"

  def password_reset_mail(user)
    @user = user
    mail(to: @user.email, subject: "Password reset instructions for Realifex")
  end

end