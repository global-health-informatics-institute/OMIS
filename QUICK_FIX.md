# Quick Fix for IPC Email Delivery

## IMMEDIATE ACTION REQUIRED:

### 1. Generate New Gmail App Password (5 minutes)
1. Go to: https://myaccount.google.com/apppasswords
2. If prompted, sign in with mkhalipiwatipatso@gmail.com
3. Under "Select app", choose "Mail"
4. Under "Select device", choose "Other (Custom name)"
5. Enter "OMIS Development" and click "Generate"
6. Copy the 16-character password (example: abcd efgh ijkl mnop)

### 2. Update Configuration (2 minutes)
Run this command in your terminal:
```bash
cd /home/watipasomkhalipi/Desktop/OMIS
export GMAIL_APP_PASSWORD='your_16_character_password_here'
```

### 3. Restart Rails Server
```bash
rails server
```

### 4. Test Email Delivery
```bash
ruby test_email_delivery.rb
```

## Current Status:
✅ IPC member selection logic is working correctly
✅ Email content is being generated properly  
✅ Email addresses are being found (though data needs cleanup)
❌ SMTP authentication is failing (this is the main blocker)

## After Fix:
- IPC members will receive meeting invitations
- Email delivery will work for all notifications
- The system will function as intended

## Data Cleanup (Optional but Recommended):
- Update employee email addresses to their actual emails
- Assign proper IPC designations to relevant staff members
