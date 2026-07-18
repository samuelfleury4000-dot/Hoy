#!/usr/bin/env bash

BASE=".nuvyra"
LOG="$BASE/logs/alert_monitor.log"
STATUS="$BASE/logs/alert.status"

mkdir -p "$BASE/logs"

echo "NUVYRA ALERT MONITOR START" > "$STATUS"

while true
do

LATEST=$(ls -t "$BASE/reports"/*.txt 2>/dev/null | head -1)

if [ -f "$LATEST" ]; then

ERRORS=$(grep -E "BUILD FAILED|CRITICAL|VULNERABILITY|SECURITY BREACH"|404 Not Found" "$LATEST" | wc -l)

if [ "$ERRORS" -gt 0 ]; then

MESSAGE="⚠️ NUVYRA ALERTE : problème détecté dans audit"

echo "$(date) $MESSAGE" >> "$LOG"
echo "$MESSAGE" > "$STATUS"

echo ""
echo "$MESSAGE"
echo "Rapport: $LATEST"

else

echo "$(date) OK aucun problème" >> "$LOG"

fi

fi

sleep 60

done
