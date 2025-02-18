# frozen_string_literal: true

class UserMailer < ApplicationMailer # rubocop:disable Style/Documentation
  def welcome_email(user, password)
    @user = User.find_by_username(user)
    @password = password
    unless @user && @user.employee && @user.employee.person # rubocop:disable Style/SafeNavigation
      raise "The username for this email not : #{user}"
    end

    mail(to: @user.employee.person.email_address, subject: 'Welcome to OMIS')
  end

  def password_reset_email(user, person, password)
    @user = user
    @person = person
    @password = password
    mail(to: @person.email_address, from: 'ghii_omis@outlook.com', subject: 'OMIS Password Reset')
  end
end
