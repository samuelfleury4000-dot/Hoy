#!/bin/bash

set -e

BASE=".nuvyra"
REPORT="$BASE/reports/NUVYRA_INTELLIGENCE_REPORT.txt"
DATA="$BASE/logs/history.csv"

mkdir -p "$BASE/reports"
mkdir -p "$BASE/logs"

if [ ! -f "$DATA" ]; then
echo "date,score,build,security,files,size" > "$DATA"
fi

DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "================================"
echo " NUVYRA INTELLIGENCE ENGINE"
echo "================================"

echo
echo "Collecte données..."

FILES=$(find src -type f | wc -l)
SIZE=$(du -sh src | awk '{print $1}')

BUILD=0
if npm run build >/dev/null 2>&1
then
BUILD=1
fi


SECURITY=1

if grep -R "0x[a-fA-F0-9]\{64\}\|PRIVATE_KEY\|SECRET_KEY" src >/dev/null 2>&1
then
SECURITY=0
fi


SCORE=0

[ $BUILD -eq 1 ] && SCORE=$((SCORE+35))
[ $SECURITY -eq 1 ] && SCORE=$((SCORE+35))

if [ "$FILES" -gt 10 ]
then
SCORE=$((SCORE+15))
fi

if [ "$SIZE" != "" ]
then
SCORE=$((SCORE+15))
fi


echo "$DATE,$SCORE,$BUILD,$SECURITY,$FILES,$SIZE" >> "$DATA"


{
echo "================================"
echo " NUVYRA INTELLIGENCE REPORT"
echo "================================"
echo
echo "DATE:"
echo "$DATE"

echo
echo "SYSTEM SCORE"
echo "$SCORE / 100"

echo
echo "BUILD"
if [ $BUILD -eq 1 ]
then
echo "PASS"
else
echo "FAIL"
fi

echo
echo "SECURITY"
if [ $SECURITY -eq 1 ]
then
echo "CLEAN"
else
echo "WARNING"
fi

echo
echo "PROJECT"
echo "FILES: $FILES"
echo "SIZE: $SIZE"

echo
echo "HISTORY"
tail -5 "$DATA"

echo
echo "STATUS"

if [ $SCORE -ge 90 ]
then
echo "🟢 EXCELLENT"
elif [ $SCORE -ge 70 ]
then
echo "🟡 ATTENTION"
else
echo "🔴 CRITICAL"
fi

} | tee "$REPORT"

echo
echo "REPORT:"
echo "$REPORT"

