#!/usr/bin/env bash

BASE=".nuvyra"
LOG="$BASE/logs/guardian.log"
STATUS="$BASE/logs/guardian.status"
REPORT="$BASE/reports/report_$(date +%Y%m%d_%H%M%S).txt"
LOCK="$BASE/logs/BLOCKED"

mkdir -p "$BASE/logs" "$BASE/reports" "$BASE/backups"

echo "================================" >> "$LOG"
echo "NUVYRA GUARDIAN" >> "$LOG"
date >> "$LOG"


if [ -f "$LOCK" ]; then
echo "BLOCKED" > "$STATUS"
exit 1
fi


ERRORS=0


echo "===== SYSTEM =====" >> "$REPORT"
node -v >> "$REPORT"
npm -v >> "$REPORT"


echo "" >> "$REPORT"
echo "===== BUILD =====" >> "$REPORT"

npm run build >> "$REPORT" 2>&1 || ERRORS=$((ERRORS+1))


echo "" >> "$REPORT"
echo "===== DEPENDENCIES =====" >> "$REPORT"

npm audit --omit=dev >> "$REPORT" 2>&1 || ERRORS=$((ERRORS+1))


echo "" >> "$REPORT"
echo "===== SECURITY =====" >> "$REPORT"

bash .nuvyra/modules/security_scan.sh >> "$REPORT"


echo "" >> "$REPORT"
echo "===== DISK =====" >> "$REPORT"

df -h >> "$REPORT"


AVAILABLE=$(df / | awk 'NR==2 {print $4}')


if [ "$AVAILABLE" -lt 500000 ]; then

echo "LOW DISK SPACE" >> "$LOG"

tar -czf \
"$BASE/backups/emergency_$(date +%s).tar.gz" \
.nuvyra \
2>/dev/null || true

echo "BLOCKED" > "$STATUS"

touch "$LOCK"

exit 1

fi


if [ "$ERRORS" -gt 2 ]; then

echo "WARNING" > "$STATUS"
echo "Problemes détectés: $ERRORS" >> "$LOG"

else

echo "OK" > "$STATUS"
echo "SYSTEM STABLE" >> "$LOG"

fi


echo "$REPORT" >> "$LOG"

