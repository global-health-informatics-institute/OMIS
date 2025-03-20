class ApplicationMailer < ActionMailer::Base
  default from: "ghii_omis@outlook.com"  # Ensure it matches your SMTP settings
  layout "mailer"
end
