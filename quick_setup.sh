#!/bin/bash

echo "=== Quick Gmail Setup for OMIS ==="
echo

# Generate app password instructions
echo "1. Generate App Password for mkhalipiwatipatso@gmail.com:"
echo "   Go to: https://myaccount.google.com/apppasswords"
echo "   Sign in with: mkhalipiwatipatso@gmail.com"
echo "   Select: Mail → Other (Custom name) → OMIS Development"
echo "   Copy the 16-character password"
echo

# Get password from user
read -p "2. Enter your 16-character Gmail app password: " gmail_password

if [ ${#gmail_password} -eq 16 ]; then
    echo "✓ Password length looks correct (16 characters)"
    
    # Update the configuration file
    sed -i "s/your_gmail_app_password_here/$gmail_password/g" /home/watipasomkhalipi/Desktop/OMIS/config/environments/development.rb
    
    echo "✓ Configuration updated successfully!"
    echo
    echo "3. Restart Rails server:"
    echo "   cd /home/watipasomkhalipi/Desktop/OMIS"
    echo "   rails server"
    echo
    echo "4. Test email delivery:"
    echo "   ruby test_email_delivery.rb"
else
    echo "✗ Error: Password should be 16 characters long"
    echo "   You entered: ${#gmail_password} characters"
fi
