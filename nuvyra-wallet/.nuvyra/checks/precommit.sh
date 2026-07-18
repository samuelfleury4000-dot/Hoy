#!/bin/bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REPORT="$ROOT/.nuvyra/reports/PRECOMMIT_REPORT.txt"

mkdir -p "$ROOT/.nuvyra/reports"

echo "===== NUVYRA PRECOMMIT CHECK =====" > "$REPORT"

cd "$ROOT" || exit 1

echo "" >> "$REPORT"
echo "===== BUILD =====" >> "$REPORT"

npm run build >> "$REPORT" 2>&1

if [ $? -ne 0 ]; then
    echo "FAIL: BUILD FAILED" >> "$REPORT"
    cat "$REPORT"
    exit 1
fi

echo "PASS: BUILD OK" >> "$REPORT"

echo "" >> "$REPORT"
echo "===== ENGINE =====" >> "$REPORT"

bash "$ROOT/.nuvyra/engine.sh" >> "$REPORT" 2>&1

if [ $? -ne 0 ]; then
    echo "FAIL: ENGINE FAILED" >> "$REPORT"
    cat "$REPORT"
    exit 1
fi

echo "PASS: ENGINE OK" >> "$REPORT"

echo "" >> "$REPORT"
echo "===== END =====" >> "$REPORT"

cat "$REPORT"

exit 0
