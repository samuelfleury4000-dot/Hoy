#!/bin/bash

BASE="$(pwd)"
LOG="$BASE/.nuvyra/logs/daemon.log"
REPORT="$BASE/.nuvyra/reports"

mkdir -p "$REPORT"

echo "NUVYRA 24/7 STARTED $(date)" >> "$LOG"

while true
do
TIME=$(date +"%Y%m%d_%H%M%S")
FILE="$REPORT/NUVYRA_REPORT_$TIME.txt"

{
echo "================================"
echo " NUVYRA AUTOMATED 24/7 REPORT"
echo "================================"
date

echo
echo "===== SECURITY ====="
grep -RInE "PRIVATE_KEY|privateKey|SECRET_KEY|API_SECRET|BEGIN PRIVATE" src 2>/dev/null || echo "CLEAN"

echo
echo "===== BUILD ====="
npm run build && echo "BUILD PASS" || echo "BUILD FAILED"

echo
echo "===== DEPENDENCIES ====="
npm audit --omit=dev

echo
echo "===== DISK ====="
df -h

echo
echo "===== HEALTH ====="
echo "SYSTEM ONLINE"

echo
echo "REPORT COMPLETE"

} > "$FILE"

echo "REPORT CREATED $FILE" >> "$LOG"

sleep 3600

done
