#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"

npm run build >/dev/null 2>&1

if [ $? -eq 0 ]; then
echo PASS > "$BASE/reports/build.txt"
else
echo FAIL > "$BASE/reports/build.txt"
fi
