#!/usr/bin/env bash

REPORT=".nuvyra/reports/NUVYRA_AUDIT_FINAL.txt"
LAST=".nuvyra/logs/last_status"


bash .nuvyra/compact_audit.sh >/dev/null 2>&1


STATUS=$(grep "SCORE FINAL" "$REPORT" 2>/dev/null)


OLD=$(cat "$LAST" 2>/dev/null)


if [ "$STATUS" != "$OLD" ]
then

echo "$STATUS" > "$LAST"


echo "🔔 NUVYRA : changement détecté"
echo "$STATUS"

else

echo "NUVYRA OK"

fi


