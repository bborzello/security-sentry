#!/bin/bash
# Path to your Discord webhook secret
WEBHOOK_URL=$(cat /home/bborz/.discord_webhook)
# File to store temporary strike counts
STRIKE_FILE="/tmp/ssh_strikes"
# File to store registry of IP addresses that attempt access
UNIQUE_IPS_LOG="/home/bborz/security-sentry/unique_attackers.txt"

# Ensure the log file exists
touch "$UNIQUE_IPS_LOG"

# Monitor the auth log in real-time
tail -Fn0 /var/log/auth.log | while read line; do
    if echo "$line" | grep -q "Failed password"; then
        # Extract the IP address
        IP=$(echo "$line" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
        
	# Silent Unique IP Tracking
	if ! grep -q "$IP" "$UNIQUE_IPS_LOG"; then
            echo "$(date) - $IP" >> "$UNIQUE_IPS_LOG"
        fi
	
        # Increment strikes for this IP
        COUNT=$(grep -c "$IP" "$STRIKE_FILE" 2>/dev/null || echo 0)
        echo "$IP" >> "$STRIKE_FILE"
        NEW_COUNT=$((COUNT + 1))

        # Strike 3: Notify Discord
        if [ "$NEW_COUNT" -eq 3 ]; then
            MESSAGE="⚠️ **Security Alert**: IP \`$IP\` has failed 3 login attempts. Monitoring closely..."
            curl -s -X POST -H "Content-Type: application/json" -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
        
        # Strike 5: BAN the IP
        elif [ "$NEW_COUNT" -ge 5 ]; then
            MESSAGE="🚫 **IP BANNED**: IP \`$IP\` reached 5 failed attempts. Dropping all future traffic."
            curl -s -X POST -H "Content-Type: application/json" -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
            
            # Use iptables to drop the traffic
            sudo iptables -A INPUT -s "$IP" -j DROP
            
            # Clear strikes for this IP so we don't spam the ban
            sed -i "/$IP/d" "$STRIKE_FILE"
        fi
    fi
done
