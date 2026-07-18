#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"

grep -R -E "PRIVATE_KEY|BEGIN PRIVATE|0x[a-fA-F0-9]{64}" src >/dev/null 2>&1

if [ $? -eq 0 ]; then
SECURITY="FAIL"
else
SECURITY="PASS"
fi

echo $SECURITY > "$BASE/reports/security.txt"
