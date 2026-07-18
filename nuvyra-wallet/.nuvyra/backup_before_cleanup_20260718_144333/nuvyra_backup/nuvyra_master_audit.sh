#!/usr/bin/env bash

BASE=".nuvyra"
REPORT="$BASE/reports/NUVYRA_MASTER_REPORT.txt"

mkdir -p "$BASE/reports" "$BASE/logs"

rm -f "$BASE"/reports/*.txt

exec > >(tee "$REPORT") 2>&1

echo "================================"
echo "        NUVYRA MASTER AUDIT"
echo "================================"
date

echo ""
echo "===== SYSTEM ====="
node -v
npm -v

echo ""
echo "===== DISK ====="
df -h | head -5

echo ""
echo "===== BUILD ====="
npm run build && echo "BUILD OK" || echo "BUILD FAILED"

echo ""
echo "===== DEPENDENCIES ====="
npm audit --audit-level=high || true

echo ""
echo "===== SECURITY ====="

grep -RInE \
--exclude-dir=node_modules \
--exclude-dir=dist \
--exclude-dir=.git \
"(PRIVATE_KEY|SECRET_KEY|MNEMONIC|seed|privateKey)" \
src/lib src/components .env 2>/dev/null \
|| echo "Aucun secret détecté"

echo ""
echo "===== WALLET ====="

grep -RInE \
"createRandom|encrypt|fromPhrase|fromEncryptedJson|sendTransaction" \
src/lib/wallet.js src/lib/transaction.js 2>/dev/null \
|| echo "Wallet scan OK"

echo ""
echo "===== BLOCKCHAIN ====="

curl -s -X POST \
-H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
https://ethereum-sepolia-rpc.publicnode.com \
|| echo "RPC ERROR"

echo ""
echo "===== PERFORMANCE ====="

du -sh src dist 2>/dev/null

echo ""
echo "===== GIT ====="

git status --short

echo ""
echo "================================"
echo " AUDIT FINI"
echo "================================"

