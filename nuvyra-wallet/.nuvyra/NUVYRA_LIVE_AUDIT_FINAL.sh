#!/bin/bash

set -e

BASE=".nuvyra"
REPORT="$BASE/reports/NUVYRA_LIVE_FINAL_REPORT.txt"
LOG="$BASE/logs/live_audit_history.csv"

mkdir -p "$BASE/reports"
mkdir -p "$BASE/logs"

if [ ! -f "$LOG" ]; then
echo "DATE,SCORE,BUILD,SECURITY,FILES,SIZE" > "$LOG"
fi

DATE=$(date)

echo "================================"
echo " NUVYRA LIVE AUDIT FINAL"
echo "================================"
echo
echo "DATE:"
echo "$DATE"


FILES=$(find src -type f | wc -l)
SIZE=$(du -sh src | awk '{print $1}')


echo
echo "===== BUILD ====="

if npm run build >/dev/null 2>&1
then
BUILD="PASS"
else
BUILD="FAIL"
fi

echo "$BUILD"


echo
echo "===== SECURITY ====="

if grep -R "0x[a-fA-F0-9]\{64\}\|PRIVATE_KEY\|SECRET_KEY" src >/dev/null 2>&1
then
SECURITY="WARNING"
else
SECURITY="PASS"
fi

echo "$SECURITY"


echo
echo "===== DEPENDENCIES ====="

npm audit --omit=dev 2>/dev/null || true


echo
echo "===== PROJECT ====="

echo "FILES: $FILES"
echo "SIZE: $SIZE"


SCORE=0

[ "$BUILD" = "PASS" ] && SCORE=$((SCORE+40))
[ "$SECURITY" = "PASS" ] && SCORE=$((SCORE+40))

if [ "$FILES" -gt 10 ]
then
SCORE=$((SCORE+10))
fi

if [ "$SIZE" != "" ]
then
SCORE=$((SCORE+10))
fi


echo "$DATE,$SCORE,$BUILD,$SECURITY,$FILES,$SIZE" >> "$LOG"


{
echo "================================"
echo " NUVYRA LIVE FINAL REPORT"
echo "================================"

echo
echo "DATE:"
echo "$DATE"

echo
echo "SCORE:"
echo "$SCORE/100"

echo
echo "BUILD:"
echo "$BUILD"

echo
echo "SECURITY:"
echo "$SECURITY"

echo
echo "FILES:"
echo "$FILES"

echo
echo "SOURCE SIZE:"
echo "$SIZE"

echo
echo "LAST AUDITS:"
tail -5 "$LOG"

echo
echo "STATUS:"

if [ "$SCORE" -eq 100 ]
then
echo "🟢 PERFECT FOUNDATION"
elif [ "$SCORE" -ge 80 ]
then
echo "🟡 GOOD"
else
echo "🔴 NEEDS FIX"
fi

} | tee "$REPORT"


echo
echo "REPORT SAVED:"
echo "$REPORT"

