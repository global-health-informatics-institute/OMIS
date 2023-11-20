class NotifierMailer < ApplicationMailer
  def new_account(recipient, password, user)
    @user = user
    @password = password
    mail(to: recipient, subject: "New OMIS Account")
  end
end
