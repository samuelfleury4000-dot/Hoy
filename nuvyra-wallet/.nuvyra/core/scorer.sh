#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"

SCORE=100

grep FAIL "$BASE/reports/security.txt" >/dev/null && SCORE=$((SCORE-50))
grep FAIL "$BASE/reports/build.txt" >/dev/null && SCORE=$((SCORE-30))

echo $SCORE > "$BASE/reports/score.txt"
