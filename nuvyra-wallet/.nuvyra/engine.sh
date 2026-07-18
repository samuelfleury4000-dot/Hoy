#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$BASE")"

REPORT="$BASE/reports/ENGINE_REPORT.txt"

mkdir -p "$BASE/reports"

echo "=================================" > "$REPORT"
echo "       NUVYRA ENGINE AUDIT" >> "$REPORT"
echo "=================================" >> "$REPORT"
date >> "$REPORT"

echo "" >> "$REPORT"
echo "===== STRUCTURE =====" >> "$REPORT"

for f in src package.json package-lock.json vite.config.js public
do
    if [ -e "$ROOT/$f" ]; then
        echo "PASS: $f" >> "$REPORT"
    else
        echo "FAIL: $f" >> "$REPORT"
    fi
done

echo "" >> "$REPORT"
echo "===== BUILD =====" >> "$REPORT"

cd "$ROOT"

npm run build >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "PASS: BUILD OK" >> "$REPORT"
else
    echo "FAIL: BUILD FAILED" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== SECURITY =====" >> "$REPORT"

SECRET=$(grep -RInE \
"(0x[a-fA-F0-9]{64}|-----BEGIN PRIVATE KEY-----|mnemonic\s*[:=]|seed\s*[:=])" \
src 2>/dev/null)

if [ -z "$SECRET" ]; then
    echo "PASS: Aucun secret réel" >> "$REPORT"
else
    echo "WARNING: Pattern sensible détecté" >> "$REPORT"
    echo "$SECRET" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== DEPENDENCIES =====" >> "$REPORT"

npm audit --production >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "PASS: npm audit OK" >> "$REPORT"
else
    echo "WARNING: npm audit problèmes" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== FINAL =====" >> "$REPORT"
echo "NUVYRA ENGINE COMPLETE" >> "$REPORT"

cat "$REPORT"
