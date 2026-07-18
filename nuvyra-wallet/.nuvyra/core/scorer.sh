#!/bin/bash

REPORT=".nuvyra/reports/ENGINE_REPORT.txt"

SCORE=100

if grep -q "WARNING" "$REPORT"; then
    SCORE=$((SCORE-10))
fi

if grep -q "FAIL" "$REPORT"; then
    SCORE=$((SCORE-40))
fi

if [ "$SCORE" -ge 90 ]; then
    STATUS="READY"
elif [ "$SCORE" -ge 60 ]; then
    STATUS="WARNING"
else
    STATUS="BLOCKED"
fi

echo "" >> "$REPORT"
echo "===== SCORE =====" >> "$REPORT"
echo "NUVYRA SCORE: $SCORE/100" >> "$REPORT"
echo "STATUS: $STATUS" >> "$REPORT"
