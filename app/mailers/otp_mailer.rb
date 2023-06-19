class OtpMailer < ApplicationMailer
  def send_otp(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: "Otp for login")
  end
end
