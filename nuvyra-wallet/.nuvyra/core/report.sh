#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"

DATE="$(date)"
SCORE="$(cat $BASE/reports/score.txt)"

echo "$DATE,$SCORE" >> "$BASE/history/audits.csv"

cat > "$BASE/reports/final_report.txt" <<REPORT
================================
 NUVYRA CORE REPORT
================================

DATE:
$DATE

SCORE:
$SCORE/100

SECURITY:
$(cat $BASE/reports/security.txt)

BUILD:
$(cat $BASE/reports/build.txt)

STATUS:
$( [ $SCORE -ge 90 ] && echo READY || echo WARNING )

================================
REPORT
