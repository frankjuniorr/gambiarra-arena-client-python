server=$(grep GAMBIARRA_URL .env | cut -d "=" -f2 | cut -d "/" -f3)

round_id=$(curl "http://${server}/session" | jq -r '.rounds[0].id')

curl -X POST "http://${server}/rounds/start" \
  -H "Content-Type: application/json" \
  -d '{"roundId":"'"$round_id"'"}'
