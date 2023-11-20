require 'action_mailer'

# Specify settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp-mail.outlook.com',
  domain: 'outlook.com',
  port: 587,
  authentication: 'login',
  user_name: 'ghii_omis@outlook.com',
  password: 'U4Sy5QXAjLthXNd',
  enable_starttls_auto: true
}

# Send email
ActionMailer::Base.new.mail(
  from: 'ghii_omis@outlook.com',
  to: 'timothy.mtonga@ghii.org',
  subject: 'Testing from Ruby script',
  body: "Hello, you've got mail!"
).deliver

