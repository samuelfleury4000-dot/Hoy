#!/usr/bin/env bash

OUT="NUVYRA_CORE_ANALYSIS.txt"

rm -f "$OUT"

echo "=================================" >> "$OUT"
echo "        NUVYRA CORE EXPORT" >> "$OUT"
echo "=================================" >> "$OUT"
date >> "$OUT"
echo "" >> "$OUT"

FILES=(
"package.json"
"vite.config.js"
"src/App.jsx"
"src/main.jsx"
"src/styles.css"
"src/lib/wallet.js"
"src/lib/security.js"
"src/lib/transaction.js"
"src/lib/config.js"
"src/lib/history.js"
"src/components/WalletSetup.jsx"
"src/components/Dashboard.jsx"
"src/components/SendCrypto.jsx"
)

for FILE in "${FILES[@]}"
do
    if [ -f "$FILE" ]; then
        echo "=================================" >> "$OUT"
        echo "FILE: $FILE" >> "$OUT"
        echo "=================================" >> "$OUT"
        cat "$FILE" >> "$OUT"
        echo "" >> "$OUT"
    fi
done

echo "=================================" >> "$OUT"
echo "        NUVYRA AUDIT SYSTEM" >> "$OUT"
echo "=================================" >> "$OUT"

find .nuvyra -maxdepth 2 -type f \
! -name "*.log" \
! -path "*/backups/*" \
-exec sh -c '
echo "================================="
echo "FILE: $1"
echo "================================="
cat "$1"
echo ""
' _ {} \; >> "$OUT" 2>/dev/null

echo "Export terminé : $OUT"
