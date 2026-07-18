#!/usr/bin/env bash

BASE=".nuvyra"
LOG="$BASE/logs/readonly_guardian.log"
REPORT="$BASE/reports/current_status.txt"

mkdir -p "$BASE/logs" "$BASE/reports"

echo "================================" > "$REPORT"
echo "      NUVYRA READ ONLY GUARDIAN" >> "$REPORT"
echo "================================" >> "$REPORT"
date >> "$REPORT"


echo "" >> "$REPORT"
echo "===== WALLET FILE PROTECTION =====" >> "$REPORT"

for DIR in src package.json vite.config.js; do
    if [ -e "$DIR" ]; then
        echo "OK : $DIR détecté" >> "$REPORT"
    else
        echo "ALERTE : $DIR absent" >> "$REPORT"
    fi
done


echo "" >> "$REPORT"
echo "===== BUILD CHECK =====" >> "$REPORT"

npm run build >> "$REPORT" 2>&1

if [ $? -eq 0 ]; then
    echo "BUILD OK" >> "$REPORT"
else
    echo "BUILD FAILED" >> "$REPORT"
fi


echo "" >> "$REPORT"
echo "===== DEPENDENCIES =====" >> "$REPORT"

npm audit --audit-level=high >> "$REPORT" 2>&1


echo "" >> "$REPORT"
echo "===== DISK =====" >> "$REPORT"

df -h >> "$REPORT"


echo "" >> "$REPORT"
echo "===== GIT CHANGES =====" >> "$REPORT"

git status --short >> "$REPORT"


echo "" >> "$REPORT"
echo "===== STATUS =====" >> "$REPORT"

echo "READ ONLY MODE ACTIVE" >> "$REPORT"
echo "$(date) Audit terminé" >> "$LOG"

