#!/bin/bash

REPORT=".nuvyra/reports/NUVYRA_LAUNCH_READINESS.txt"
mkdir -p .nuvyra/reports

PASS=0
WARN=0

check(){
TITLE="$1"
CMD="$2"

echo
echo "[$TITLE]"

if eval "$CMD" >/dev/null 2>&1; then
echo "PASS : $TITLE"
PASS=$((PASS+1))
else
echo "WARNING : $TITLE"
WARN=$((WARN+1))
fi
}

{
echo "================================"
echo " NUVYRA LAUNCH READINESS AUDIT"
echo "================================"
echo
date
echo


echo "===== PRODUCT ====="

check "React application" "[ -f src/App.jsx ]"

check "Dashboard exists" "[ -f src/components/Dashboard.jsx ]"

check "Wallet setup exists" "[ -f src/components/WalletSetup.jsx ]"

check "Send crypto exists" "[ -f src/components/SendCrypto.jsx ]"

check "Receive crypto exists" "[ -f src/components/ReceiveCrypto.jsx ]"


echo
echo "===== USER EXPERIENCE ====="

check "Password security rules" "grep -R 'MIN_PASSWORD' src/security"

check "Seed warning exists" "grep -R 'phrase secrète\\|sauvegarde' src/components"

check "Error handling exists" "grep -R 'catch' src"


echo
echo "===== SECURITY ====="

check "Encryption enabled" "grep -R 'encrypt' src/lib/wallet.js"

check "Private key protection" "! grep -R '0x[a-fA-F0-9]\{64\}' src"

check "Environment ignored" "grep -q '.env' .gitignore"


echo
echo "===== BLOCKCHAIN ====="

check "Ethers installed" "npm list ethers"

check "Network system" "[ -f src/lib/network.js ]"

check "Transaction system" "[ -f src/lib/transaction.js ]"


echo
echo "===== PERFORMANCE ====="

SIZE=$(du -sh dist 2>/dev/null | awk '{print $1}')

echo "BUILD SIZE: $SIZE"

echo
echo "===== MARKET READINESS ====="

if [ -f src/components/PriceCard.jsx ]; then
echo "PASS : Price display"
PASS=$((PASS+1))
else
echo "WARNING : Missing market display"
WARN=$((WARN+1))
fi


echo
echo "===== SCORE ====="

TOTAL=$((PASS+WARN))

SCORE=$((PASS*100/TOTAL))

echo
echo "CHECKS:"
echo "$TOTAL"

echo "PASS:"
echo "$PASS"

echo "WARN:"
echo "$WARN"

echo
echo "LAUNCH SCORE:"
echo "$SCORE / 100"


if [ "$SCORE" -ge 90 ]; then
echo "STATUS: 🟢 READY FOUNDATION"
elif [ "$SCORE" -ge 75 ]; then
echo "STATUS: 🟡 IMPROVEMENTS REQUIRED"
else
echo "STATUS: 🔴 NOT READY"
fi


echo
echo "================================"
echo " END AUDIT"
echo "================================"

} | tee "$REPORT"
