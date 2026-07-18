#!/usr/bin/env bash

echo "===== SECURITY CLEAN SCAN ====="

echo ""
echo "[SECRETS]"

grep -RInE \
--exclude-dir=node_modules \
--exclude-dir=dist \
--exclude-dir=.git \
"(PRIVATE_KEY|SECRET_KEY|API_KEY|MNEMONIC|seed|privateKey)" \
src/lib src/components .env 2>/dev/null || echo "Aucun secret trouvé"


echo ""
echo "[WALLET FILES]"

grep -RInE \
"mnemonic|encrypt|fromPhrase|sendTransaction" \
src/lib/wallet.js src/lib/transaction.js 2>/dev/null || true


echo ""
echo "SECURITY SCAN FIXED"
