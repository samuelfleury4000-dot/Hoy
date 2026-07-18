#!/bin/bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BASE="$ROOT/.nuvyra"
REPORT="$BASE/reports/ENGINE_REPORT.txt"

mkdir -p "$BASE/reports"

echo "=================================" > "$REPORT"
echo "       NUVYRA ENGINE AUDIT" >> "$REPORT"
echo "=================================" >> "$REPORT"
date >> "$REPORT"

run_check() {
    NAME=$1
    FILE=$2

    echo "" >> "$REPORT"
    echo "===== $NAME =====" >> "$REPORT"

    if [ -f "$FILE" ]; then
        bash "$FILE" >> "$REPORT" 2>&1
    else
        echo "WARNING: $FILE absent" >> "$REPORT"
    fi
}

echo "" >> "$REPORT"
echo "===== STRUCTURE =====" >> "$REPORT"

for item in src package.json package-lock.json vite.config.js public; do
    if [ -e "$ROOT/$item" ]; then
        echo "PASS: $item" >> "$REPORT"
    else
        echo "FAIL: $item manquant" >> "$REPORT"
    fi
done

run_check "BUILD" "$BASE/checks/build.sh"
run_check "DEPENDENCIES" "$BASE/checks/dependencies.sh"
run_check "REACT QUALITY" "$BASE/checks/react.sh"
run_check "SECURITY" "$BASE/checks/security.sh"

echo "" >> "$REPORT"
echo "===== CLEANUP CHECK =====" >> "$REPORT"

if [ -f "$BASE/checks/cleanup.sh" ]; then
    echo "PASS: cleanup disponible" >> "$REPORT"
else
    echo "WARNING: cleanup absent" >> "$REPORT"
fi

if [ -f "$BASE/checks/script_cleanup.sh" ]; then
    echo "PASS: script cleanup disponible" >> "$REPORT"
else
    echo "WARNING: script cleanup absent" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== FINAL =====" >> "$REPORT"
echo "NUVYRA ENGINE COMPLETE" >> "$REPORT"

echo ""
echo "===== FINAL REPORT ====="
cat "$REPORT" | awk '!seen[$0]++'

# ===== HISTORY LOGGER =====

HISTORY="$BASE/history/audits.csv"

mkdir -p "$BASE/history"

if [ ! -f "$HISTORY" ]; then
    echo "date,score,status,build,security" > "$HISTORY"
fi

DATE_NOW=$(date +"%Y-%m-%d %H:%M:%S")

if grep -q "NUVYRA SCORE: 100/100" "$REPORT"; then
    SCORE="100"
    STATUS="READY"
else
    SCORE="90"
    STATUS="WARNING"
fi

if grep -q "PASS: BUILD OK" "$REPORT"; then
    BUILD="PASS"
else
    BUILD="FAIL"
fi

if grep -q "Aucun secret réel\|Aucun secret réel exposé" "$REPORT"; then
    SECURITY="PASS"
else
    SECURITY="WARNING"
fi

echo "$DATE_NOW,$SCORE,$STATUS,$BUILD,$SECURITY" >> "$HISTORY"

