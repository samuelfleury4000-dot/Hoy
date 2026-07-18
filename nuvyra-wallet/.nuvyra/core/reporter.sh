#!/bin/bash
BASE="$(dirname $(dirname "$0"))"
DATE=$(date)
SCORE=$(cat "$BASE/reports/score.txt")

echo "$DATE,$SCORE" >> "$BASE/history/audits.csv"

cat > "$BASE/dashboard/data.json" <<JSON
{
"date":"$DATE",
"score":$SCORE,
"history":[
{"date":"$DATE","score":$SCORE}
]
}
JSON

echo "NUVYRA SCORE: $SCORE/100" > "$BASE/reports/latest.txt"
