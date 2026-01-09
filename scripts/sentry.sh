#!/bin/bash
# Read the webhook from your secret file
WEBHOOK_URL=$(cat /home/bborz/.discord_webhook)

if [ "$PAM_TYPE" != "close_session" ]; then
    PAYLOAD="{\"content\": \"🚀 **SSH Login Detected**\n**User:** $PAM_USER\n**Remote IP:** $PAM_RHOST\n**Server:** $(hostname)\"}"
    
    # The '&' at the end sends this to the background immediately
    # The '-m 2' tells curl to give up after 2 seconds
    curl -s -m 2 -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK_URL" > /dev/null 2>&1 &
fi
