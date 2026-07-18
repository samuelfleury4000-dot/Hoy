#!/bin/bash
set -e

DATE=$(date +%Y%m%d_%H%M%S)
REPORT=".nuvyra/reports/NUVYRA_COMPLETE_AUDIT_$DATE.txt"

mkdir -p .nuvyra/reports

SCORE=100
CRITICAL=0
WARNING=0
INFO=0

exec > >(tee "$REPORT") 2>&1

echo "================================"
echo "     NUVYRA ONE CLICK AUDIT"
echo "================================"
echo "DATE: $(date)"
echo ""

echo "===== SYSTEM ====="
node -v
npm -v

echo ""
echo "===== STRUCTURE ====="

for file in \
src/App.jsx \
src/main.jsx \
src/lib/wallet.js \
src/lib/transaction.js \
src/components/WalletSetup.jsx
do
    if [ -f "$file" ]; then
        echo "PASS: $file"
    else
        echo "CRITICAL: Missing $file"
        SCORE=$((SCORE-15))
        CRITICAL=$((CRITICAL+1))
    fi
done

echo ""
echo "===== SECURITY ====="

if grep -RInE "0x[a-fA-F0-9]{64}|PRIVATE_KEY|SECRET_KEY|BEGIN PRIVATE" src .env 2>/dev/null; then
    echo "CRITICAL: Secret potentiel détecté"
    SCORE=$((SCORE-40))
    CRITICAL=$((CRITICAL+1))
else
    echo "PASS: Aucun secret privé trouvé"
fi

echo ""
echo "===== DEPENDENCIES ====="

if npm audit --audit-level=high >/dev/null 2>&1; then
    echo "PASS: Dépendances propres"
else
    echo "WARNING: Vulnérabilité npm"
    SCORE=$((SCORE-20))
    WARNING=$((WARNING+1))
fi

echo ""
echo "===== BUILD ====="

if npm run build >/dev/null 2>&1; then
    echo "PASS: Build réussi"
else
    echo "CRITICAL: Build échoué"
    SCORE=$((SCORE-30))
    CRITICAL=$((CRITICAL+1))
fi

echo ""
echo "===== WALLET ====="

if grep -RIn "encrypt(password)" src/lib/wallet.js >/dev/null 2>&1; then
    echo "PASS: Wallet chiffré"
else
    echo "WARNING: Chiffrement absent"
    SCORE=$((SCORE-15))
    WARNING=$((WARNING+1))
fi

echo ""
echo "===== BLOCKCHAIN ====="

if grep -RIn "JsonRpcProvider" src/lib >/dev/null 2>&1; then
    echo "PASS: Provider blockchain détecté"
else
    echo "WARNING: Aucun provider trouvé"
    SCORE=$((SCORE-10))
    WARNING=$((WARNING+1))
fi

echo ""
echo "===== PERFORMANCE ====="

SIZE=$(du -sh src | awk '{print $1}')
DIST=$(du -sh dist 2>/dev/null | awk '{print $1}' || echo "N/A")

echo "SRC: $SIZE"
echo "DIST: $DIST"

echo ""
echo "===== STORAGE ====="

DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK" -lt 90 ]; then
    echo "PASS: Disque OK ($DISK%)"
else
    echo "WARNING: Disque élevé ($DISK%)"
    SCORE=$((SCORE-10))
    WARNING=$((WARNING+1))
fi

echo ""
echo "================================"
echo "        FINAL SCORE"
echo "================================"

echo "SCORE: $SCORE/100"
echo "CRITICAL: $CRITICAL"
echo "WARNING: $WARNING"
echo "INFO: $INFO"

if [ "$SCORE" -ge 90 ]; then
    echo "STATUS: 🟢 PRODUCTION READY"
elif [ "$SCORE" -ge 70 ]; then
    echo "STATUS: 🟡 NEEDS REVIEW"
else
    echo "STATUS: 🔴 NOT READY"
fi

echo ""
echo "REPORT:"
echo "$REPORT"

echo "================================"
echo " AUDIT COMPLETE"
echo "================================"
