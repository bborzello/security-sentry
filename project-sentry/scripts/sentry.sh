#!/bin/bash

WEBHOOK_URL=$(cat ~/.discord_webhook)

# Watch the auth log for successful logins
tail -Fn0 /var/log/auth.log | while read line; do
    if echo "$line" | grep -q "Accepted"; then
        # Format a nice message for Discord
        MESSAGE="🚀 **Login Detected on Noodle-Server**\n\`\`\`$line\`\`\`"
        
        # Send to Discord
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"$MESSAGE\"}" \
             $WEBHOOK_URL
    fi
done
