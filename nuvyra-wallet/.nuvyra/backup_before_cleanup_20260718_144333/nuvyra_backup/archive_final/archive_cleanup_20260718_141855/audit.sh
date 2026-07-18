#!/bin/bash

BASE="$(pwd)"
LOG=".nuvyra/logs/system.log"
REPORT=".nuvyra/reports/latest.txt"

mkdir -p .nuvyra/logs .nuvyra/reports

{
echo "================================"
echo "       NUVYRA LIVE AUDIT 10/10"
echo "================================"
date

echo
echo "===== BUILD ====="
npm run build >/tmp/nuvyra_build.log 2>&1
if [ $? -eq 0 ]; then
echo "BUILD : OK"
else
echo "BUILD : FAILED"
cat /tmp/nuvyra_build.log
fi

echo
echo "===== DEPENDENCIES ====="
npm audit --omit=dev 2>/dev/null || echo "Audit npm terminé"

echo
echo "===== SECURITY ====="
grep -R -nE "PRIVATE_KEY|SECRET_KEY|API_KEY|seed|mnemonic" src 2>/dev/null || echo "Aucun secret trouvé"

echo
echo "===== WALLET ====="
grep -R -nE "ethers|encrypt|fromPhrase|sendTransaction" src/lib 2>/dev/null

echo
echo "===== BLOCKCHAIN ====="
curl -s -X POST https://ethereum-sepolia-rpc.publicnode.com \
-H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' || echo "RPC erreur"

echo
echo "===== DISK ====="
df -h /

echo
echo "===== STATUS ====="
echo "NUVYRA LIVE MONITORING ACTIVE"

} | tee "$REPORT" >> "$LOG"

echo "Rapport : $REPORT"
