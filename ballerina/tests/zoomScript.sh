#!/bin/bash


CLIENT_ID=$(grep clientId /home/laavanja/Documents/Ballerina/module-ballerinax-zoom.meetings/ballerina/tests/Config.toml | cut -d'=' -f2 | tr -d ' "')
CLIENT_SECRET=$(grep clientSecret /home/laavanja/Documents/Ballerina/module-ballerinax-zoom.meetings/ballerina/tests/Config.toml | cut -d'=' -f2 | tr -d ' "')
ACCOUNT_ID=$(grep accountId /home/laavanja/Documents/Ballerina/module-ballerinax-zoom.meetings/ballerina/tests/Config.toml | cut -d'=' -f2 | tr -d ' "')
TOKEN_PATH="/home/laavanja/Documents/zoomToken.txt"



# Generate base64 encoded credentials
BASIC_AUTH=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64)

# Call Zoom OAuth token API
RESPONSE=$(curl -s -X POST https://zoom.us/oauth/token \
  -H "Authorization: Basic $BASIC_AUTH" \
  -d "grant_type=account_credentials&account_id=$ACCOUNT_ID")

# Extract access_token
ACCESS_TOKEN=$(echo "$RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d':' -f2 | tr -d '"')

# Save to a file
if [ -n "$ACCESS_TOKEN" ]; then
        echo "$ACCESS_TOKEN" > "$TOKEN_PATH"
else
        echo "Not successful" > "$TOKEN_PATH"
fi
