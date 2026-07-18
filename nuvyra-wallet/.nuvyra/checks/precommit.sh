#!/bin/bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REPORT="$ROOT/.nuvyra/reports/PRECOMMIT_REPORT.txt"

mkdir -p "$ROOT/.nuvyra/reports"

echo "===== NUVYRA PRECOMMIT CHECK =====" > "$REPORT"

cd "$ROOT" || exit 1

echo "" >> "$REPORT"
echo "===== BUILD =====" >> "$REPORT"

npm run build >> "$REPORT" 2>&1

if [ $? -eq 0 ]; then
    echo "PASS: BUILD OK" >> "$REPORT"
else
    echo "FAIL: BUILD FAILED" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== ENGINE =====" >> "$REPORT"

bash "$ROOT/.nuvyra/engine.sh" >> "$REPORT" 2>&1

echo "" >> "$REPORT"
echo "===== END =====" >> "$REPORT"

cat "$REPORT"
