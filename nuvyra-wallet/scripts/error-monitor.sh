#!/bin/bash

REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG="$REPORT_DIR/ERROR_$DATE.txt"
TMP=$(mktemp)

echo "===================================" > "$LOG"
echo " NUVYRA ERROR REPORT" >> "$LOG"
date >> "$LOG"
echo "===================================" >> "$LOG"
echo "" >> "$LOG"

npm run build >"$TMP" 2>&1

STATUS=$?

if [ $STATUS -eq 0 ]; then

echo "Aucune erreur détectée." >> "$LOG"

else

echo "BUILD : ECHEC" >> "$LOG"
echo "" >> "$LOG"

grep -E "error|Error|ERROR|failed|Failed|Build failed|not exported|Cannot|Unexpected|ReferenceError|SyntaxError|TypeError|Rollup|Vite|imported by|file:" "$TMP" >> "$LOG"

echo "" >> "$LOG"
echo "===== LOG COMPLET =====" >> "$LOG"

cat "$TMP" >> "$LOG"

fi

rm "$TMP"

echo
echo "Rapport créé : $LOG"
