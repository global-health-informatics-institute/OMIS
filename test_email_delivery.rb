#!/usr/bin/env ruby

# Simple script to test email delivery and verify IPC member emails
require_relative 'config/environment'

puts "=== Email Delivery Test ==="
puts "Current SMTP Settings:"
puts "  Address: #{Rails.application.config.action_mailer.smtp_settings[:address]}"
puts "  Port: #{Rails.application.config.action_mailer.smtp_settings[:port]}"
puts "  Username: #{Rails.application.config.action_mailer.smtp_settings[:user_name]}"
puts "  Password: #{Rails.application.config.action_mailer.smtp_settings[:password]&.length || 0} characters"
puts

# Test basic email delivery
begin
  test_email = RequisitionMailer.notify_ipc_members(
    Requisition.first,
    Employee.first,
    Date.today,
    Time.current
  )
  
  puts "✓ Email object created successfully"
  puts "  To: #{test_email.to}"
  puts "  Subject: #{test_email.subject}"
  
  # Try to deliver the email
  test_email.deliver_now
  puts "✓ Email delivered successfully!"
  
rescue => e
  puts "✗ Email delivery failed:"
  puts "  Error: #{e.message}"
  puts "  Type: #{e.class.name}"
end

puts
puts "=== IPC Member Email Verification ==="

# Check for employees who might be IPC members
employees = Employee.where(still_employed: true).includes(:person).limit(10)

employees.each do |employee|
  next unless employee.person
  
  official_email = employee.person.official_email
  personal_email = employee.person.email_address
  
  puts "Employee: #{employee.person.full_name}"
  puts "  Official Email: #{official_email || 'NOT SET'}"
  puts "  Personal Email: #{personal_email || 'NOT SET'}"
  puts "  Will Use: #{official_email || personal_email || 'NO EMAIL'}"
  puts
end

puts "=== Instructions ==="
puts "1. Set your Gmail app password as environment variable:"
puts "   export GMAIL_APP_PASSWORD='your_16_character_app_password'"
puts "2. Or update the password in config/environments/development.rb"
puts "3. Make sure 2-factor authentication is enabled on the Gmail account"
puts "4. Generate a new app password if needed: https://myaccount.google.com/apppasswords"
