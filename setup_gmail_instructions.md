# Gmail SMTP Setup Instructions

## Step 1: Enable 2-Factor Authentication
1. Go to https://myaccount.google.com/security
2. Enable 2-Step Verification if not already enabled

## Step 2: Generate App Password
1. Go to https://myaccount.google.com/apppasswords
2. Select "Mail" from the app dropdown
3. Select "Other (Custom name)" and enter "OMIS Development"
4. Click "Generate"
5. Copy the 16-character password (without spaces)

## Step 3: Update Configuration
Option A: Set Environment Variable (Recommended)
```bash
export GMAIL_APP_PASSWORD='your_16_character_password_here'
```

Option B: Update Configuration File
Edit config/environments/development.rb and replace:
```ruby
password: ENV['GMAIL_APP_PASSWORD'] || 'your_gmail_app_password_here',
```
with:
```ruby
password: 'your_actual_16_character_password_here',
```

## Step 4: Restart Rails Server
```bash
rails server
```

## Step 5: Test Email Delivery
```bash
ruby test_email_delivery.rb
```

## Important Notes:
- The app password is 16 characters long
- No spaces needed
- Different from your regular Gmail password
- Keep it secure and don't commit to version control
