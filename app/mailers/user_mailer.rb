class UserMailer < ApplicationMailer
  def welcome_email(user, password)
    @user = User.find_by_username(user)
    mail(to: @user.employee.person.email_address, subject: 'Welcome to OMIS')
  end

  def password_reset_email(user, person, password)
    @user = user
    @person = person
    @password = password
    mail(to: @person.email_address, from: 'ghii_omis@outlook.com', subject: 'OMIS Password Reset')
  end
end
