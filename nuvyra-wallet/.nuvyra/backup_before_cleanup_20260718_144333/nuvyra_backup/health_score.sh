#!/usr/bin/env bash

echo "=============================="
echo "       NUVYRA HEALTH"
echo "=============================="

SCORE=100

if npm run build >/dev/null 2>&1; then
 echo "BUILD       OK"
else
 echo "BUILD       FAIL"
 SCORE=$((SCORE-30))
fi

if npm audit --audit-level=high >/dev/null 2>&1; then
 echo "SECURITY    OK"
else
 echo "SECURITY    WARN"
 SCORE=$((SCORE-20))
fi

if [ -d dist ]; then
 echo "DIST        OK"
else
 echo "DIST        FAIL"
 SCORE=$((SCORE-20))
fi

echo ""
echo "FINAL SCORE: $SCORE/100"

if [ "$SCORE" -ge 90 ]; then
 echo "STATUS: READY"
else
 echo "STATUS: REVIEW"
fi
