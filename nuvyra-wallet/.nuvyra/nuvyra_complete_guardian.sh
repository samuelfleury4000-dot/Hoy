#!/usr/bin/env bash

set -o pipefail

BASE=".nuvyra"
REPORT="$BASE/reports/NUVYRA_FINAL_REPORT.txt"
LOG="$BASE/logs/guardian.log"
LOCK="$BASE/guardian.lock"

mkdir -p "$BASE/reports" "$BASE/logs"

if [ -f "$LOCK" ]; then
    PID=$(cat "$LOCK")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Guardian déjà actif PID=$PID"
        exit 0
    fi
fi

echo $$ > "$LOCK"

cleanup(){
    rm -f "$LOCK"
}
trap cleanup EXIT


audit(){

rm -f "$BASE/reports/"*.txt

CRITICAL=0
WARN=0


exec > >(tee "$REPORT") 2>&1


echo "================================"
echo "      NUVYRA COMPLETE GUARDIAN"
echo "================================"
date


echo ""
echo "===== SYSTEM ====="

node -v
npm -v


echo ""
echo "===== DISK ====="

df -h | grep -E "/vscode|/workspaces"

DISK=$(df /vscode | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK" -gt 95 ]; then
    echo "CRITIQUE: espace disque"
    CRITICAL=$((CRITICAL+1))
fi



echo ""
echo "===== BUILD ====="

npm run build

if [ $? -ne 0 ]; then
    echo "BUILD FAILED"
    CRITICAL=$((CRITICAL+1))
else
    echo "BUILD OK"
fi



echo ""
echo "===== DEPENDENCIES ====="

npm audit --audit-level=high

if [ $? -ne 0 ]; then
    WARN=$((WARN+1))
fi



echo ""
echo "===== SECURITY ====="


SECRETS=$(grep -RInE \
--exclude-dir=node_modules \
--exclude-dir=dist \
--exclude-dir=.git \
"(PRIVATE_KEY|SECRET_KEY|API_SECRET|PRIVATEKEY)[[:space:]]*=[[:space:]]*['\"]?[A-Za-z0-9_-]{20,}" \
. 2>/dev/null)


if [ -n "$SECRETS" ]; then
    echo "$SECRETS"
    CRITICAL=$((CRITICAL+1))
else
    echo "Aucun secret exposé"
fi



echo ""
echo "===== WALLET ====="


grep -RInE \
"createRandom|encrypt|fromPhrase|fromEncryptedJson|sendTransaction" \
src/lib src/components 2>/dev/null


echo ""
echo "===== BLOCKCHAIN ====="


RPC=$(curl -s -X POST \
-H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
https://ethereum-sepolia-rpc.publicnode.com)


echo "$RPC"


if [[ "$RPC" != *"result"* ]]; then
    WARN=$((WARN+1))
fi



echo ""
echo "===== PERFORMANCE ====="

du -sh src dist 2>/dev/null



echo ""
echo "===== GIT ====="

git status --short



TOTAL=100

TOTAL=$((TOTAL - CRITICAL*25))
TOTAL=$((TOTAL - WARN*5))

if [ "$TOTAL" -lt 0 ]; then
TOTAL=0
fi


echo ""
echo "================================"
echo " SCORE SANTE : $TOTAL/100"
echo " CRITIQUES : $CRITICAL"
echo " ALERTES : $WARN"
echo "================================"


if [ "$CRITICAL" -gt 0 ]; then

echo "SYSTEME BLOQUE : PROBLEME CRITIQUE"

echo "$(date) CRITICAL=$CRITICAL" >> "$LOG"

else

echo "$(date) SYSTEM STABLE SCORE=$TOTAL" >> "$LOG"

fi


}


while true
do

audit

sleep 300

done

