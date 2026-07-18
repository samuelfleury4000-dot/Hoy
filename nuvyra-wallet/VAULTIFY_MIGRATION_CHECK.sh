#!/bin/bash

echo "================================"
echo " VAULTIFY VS NUVYRA AUDIT"
echo "================================"

echo ""
echo "===== VAULTIFY FILES ====="

find vaultify-wallet -type f \
-not -path "*/node_modules/*" \
-not -path "*/dist/*" \
2>/dev/null


echo ""
echo "===== NUVYRA FILES ====="

find nuvyra-wallet -type f \
-not -path "*/node_modules/*" \
-not -path "*/dist/*" \
2>/dev/null


echo ""
echo "===== SEARCH IMPORTANT FUNCTIONS ====="

echo "--- Wallet ---"

grep -R "createWallet\|encrypt\|mnemonic\|privateKey\|sendTransaction" \
vaultify-wallet \
nuvyra-wallet \
2>/dev/null


echo ""
echo "--- Security ---"

grep -R "security\|password\|storage\|localStorage" \
vaultify-wallet \
nuvyra-wallet \
2>/dev/null


echo ""
echo "--- Dependencies ---"

echo "VAULTIFY:"
cat vaultify-wallet/package.json 2>/dev/null

echo ""
echo "NUVYRA:"
cat nuvyra-wallet/package.json 2>/dev/null


echo ""
echo "================================"
echo " AUDIT COMPLETE"
echo "================================"

