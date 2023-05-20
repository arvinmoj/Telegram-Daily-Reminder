#!/bin/bash

# ENV
CHAT_ID=$(cat .env | grep CHAT_ID | cut -d '=' -f 2)
OPENAI_API_KEY=$(cat .env | grep OPENAI_API_KEY | cut -d '=' -f 2)
TELEGRAM_API_KEY=$(cat .env | grep TELEGRAM_API_KEY | cut -d '=' -f 2)

URL="https://api.telegram.org/bot$TELEGRAM_API_KEY/sendMessage"

#Accepting the two dates from the user
DATE1="2000-12-04"
DATE2=$(date +"%Y-%m-%d")

#Converting the dates to Unix timestamps
timestamp1=$(date -d "$DATE1" +%s)
timestamp2=$(date -d "$DATE2" +%s)

#Finding the difference between the timestamps in seconds
difference=$((timestamp2 - timestamp1))

#Converting the seconds to days
DAYS=$((difference / (60*60*24)))

echo "The number of days between $DATE1 and $DATE2 is $DAYS."

 # Get Quates 
# curl --request GET 'https://api.adviceslip.com/advice' > ./result.json

QUOTES=$(curl https://api.openai.com/v1/completions \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
  "model": "text-davinci-003",
  "prompt": "Quote from a famous person: \n\n",
  "temperature": 0.9,
  "max_tokens": 4000,
  "top_p": 1.0,
  "frequency_penalty": 0.9,
  "presence_penalty": 0.9
}')

QUOTES=$(echo $QUOTES | jq -r '.choices[0].text')
    
# Generate Emoji
EMJ_2=`printf "\U$(printf '%x' $((RANDOM%79+128512)))"`
EMJ_3=`printf "\U$(printf '%x' $((RANDOM%79+128512)))"`
EMJ_1=`printf "\U$(printf '%x' $((RANDOM%79+128512)))"`

# Format Message 
MESSAGE="Happy $DAYS New Day"

# Send Line
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="--------------------------------"
echo "--------------------------------"
# Send Message
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"
echo "$MESSAGE"
# Send EMJ
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$EMJ_1 $EMJ_2 $EMJ_3"
echo "$EMJ_1 $EMJ_2 $EMJ_3"
# Send Quotes
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$QUOTES"
echo "$QUOTES"