#!/usr/bin/env bash

set -o pipefail

BASE=".nuvyra"
REPORT_DIR="$BASE/reports"
LOG="$BASE/logs/daemon.log"
FINAL="$REPORT_DIR/NUVYRA_AUTO_FINAL.txt"

mkdir -p "$REPORT_DIR" "$BASE/logs"

while true
do

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT="$REPORT_DIR/audit_$DATE.txt"

echo "================================" > "$REPORT"
echo "       NUVYRA AUTO AUDIT" >> "$REPORT"
echo "================================" >> "$REPORT"
echo "Date: $(date)" >> "$REPORT"
echo "" >> "$REPORT"


echo "===== SYSTEM =====" >> "$REPORT"
node -v >> "$REPORT"
npm -v >> "$REPORT"


echo "" >> "$REPORT"
echo "===== BUILD =====" >> "$REPORT"

npm run build >> "$REPORT" 2>&1

if [ $? -eq 0 ]
then
echo "BUILD STATUS : OK" >> "$REPORT"
else
echo "BUILD STATUS : FAILED" >> "$REPORT"
fi



echo "" >> "$REPORT"
echo "===== DEPENDENCIES =====" >> "$REPORT"

npm audit --omit=dev >> "$REPORT" 2>&1 || true



echo "" >> "$REPORT"
echo "===== SECURITY SCAN =====" >> "$REPORT"

grep -RInE -- -- \
"(PRIVATE_KEY|API_KEY|SECRET_KEY)[[:space:]]*=[[:space:]]*['"][^'"]+['"]|0x[a-fA-F0-9]{64}|seed[[:space:]]*=[[:space:]]*['"][^'"]+['"]" \
src \
>> "$REPORT" 2>&1 || echo "Aucun secret exposé détecté" >> "$REPORT"



echo "" >> "$REPORT"
echo "===== REACT QUALITY =====" >> "$REPORT"

echo "useEffect:" >> "$REPORT"
grep -RIn "useEffect" src >> "$REPORT" || true

echo "console.log:" >> "$REPORT"
grep -RIn "console.log" src >> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== CRYPTO WALLET =====" >> "$REPORT"

grep -RInE -- -- \
"ethers.Wallet|encrypt|fromPhrase|sendTransaction" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== BLOCKCHAIN =====" >> "$REPORT"

curl -s \
-X POST \
-H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
https://ethereum-sepolia-rpc.publicnode.com \
>> "$REPORT" 2>&1



echo "" >> "$REPORT"
echo "===== PERFORMANCE =====" >> "$REPORT"

du -sh src dist >> "$REPORT" 2>/dev/null || true



echo "" >> "$REPORT"
echo "===== GIT =====" >> "$REPORT"

git -C "$(pwd)" status --short >> "$REPORT"



echo "" >> "$REPORT"
echo "================================" >> "$REPORT"
echo "FIN AUDIT" >> "$REPORT"
echo "================================" >> "$REPORT"



cp "$REPORT" "$FINAL"



echo "$(date) Audit terminé : $REPORT" >> "$LOG"


sleep 300

done

