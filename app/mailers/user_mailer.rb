class UserMailer < ApplicationMailer
  def welcome_email(user, password)
    @user = User.find_by_username(user)
    mail(to: @user.employee.person.email_address, subject: 'Welcome to OMIS')
  end

  def password_reset_email(user, password)
    @user = user
    @password = password
    mail(to: 'timmtonga@gmail.com', from: 'ghii_omis@outlook.com', subject: 'OMIS Password Reset')
  end
end
