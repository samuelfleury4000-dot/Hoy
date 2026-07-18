#!/bin/bash

REPORT=".nuvyra/reports/MASTER_AUDIT.txt"
mkdir -p .nuvyra/reports

SCORE=100

{
echo "================================="
echo "       NUVYRA MASTER AUDIT PRO"
echo "================================="
echo "DATE: $(date)"
echo ""

echo "===== STRUCTURE ====="

for f in src package.json package-lock.json vite.config.js public; do
    if [ -e "$f" ]; then
        echo "PASS: $f"
    else
        echo "FAIL: $f missing"
        SCORE=$((SCORE-10))
    fi
done

echo ""
echo "===== BUILD ====="

if npm run build >/dev/null 2>&1; then
    echo "PASS: BUILD OK"
else
    echo "FAIL: BUILD ERROR"
    SCORE=$((SCORE-25))
fi

echo ""
echo "===== DEPENDENCIES ====="

if npm audit --omit=dev >/dev/null 2>&1; then
    echo "PASS: npm audit OK"
else
    echo "WARNING: npm vulnerabilities"
    SCORE=$((SCORE-5))
fi

echo ""
echo "===== SECURITY SCAN ====="

SECRET=$(grep -RInE \
"(0x[a-fA-F0-9]{64}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|mnemonic[[:space:]]*[:=][[:space:]]*['"'"']?[a-zA-Z0-9]{20,}|seed[[:space:]]*[:=][[:space:]]*['"'"']?[a-zA-Z0-9]{20,})" \
src 2>/dev/null)

if [ -z "$SECRET" ]; then
    echo "PASS: Aucun secret réel"
else
    echo "WARNING: Pattern sensible trouvé"
    echo "$SECRET"
    SCORE=$((SCORE-10))
fi

echo ""
echo "===== WALLET SECURITY ====="

if grep -RInE "encrypt|encrypted|cipher|fromEncryptedJson" src/lib src/components >/dev/null 2>&1; then
    echo "PASS: Wallet encryption détectée"
else
    echo "WARNING: Encryption absente"
    SCORE=$((SCORE-10))
fi

echo ""
echo "===== TRANSACTION SECURITY ====="

if [ -f "src/lib/transactionGuard.js" ]; then
    echo "PASS: Transaction guard présent"
else
    echo "WARNING: Transaction guard absent"
    SCORE=$((SCORE-5))
fi

if grep -RInE "ethers|viem|web3" src >/dev/null 2>&1; then
    echo "PASS: Librairie blockchain détectée"
else
    echo "WARNING: Librairie blockchain absente"
fi

echo ""
echo "===== PRODUCTION CHECK ====="

if grep -q ".env" .gitignore 2>/dev/null; then
    echo "PASS: .env protégé par gitignore"
else
    echo "WARNING: Vérifier .env"
    SCORE=$((SCORE-5))
fi

if grep -RInE "console\\.log|debugger" src >/dev/null 2>&1; then
    echo "WARNING: Logs debug trouvés"
    SCORE=$((SCORE-5))
else
    echo "PASS: Pas de logs debug"
fi

echo ""
echo "===== SIZE ====="

du -sh src 2>/dev/null
du -sh dist 2>/dev/null

echo ""
echo "===== FINAL SCORE ====="

if [ "$SCORE" -gt 100 ]; then
    SCORE=100
fi

echo "NUVYRA SCORE: $SCORE/100"

if [ "$SCORE" -ge 90 ]; then
    echo "STATUS: READY FOR PRODUCTION"
elif [ "$SCORE" -ge 70 ]; then
    echo "STATUS: WARNING"
else
    echo "STATUS: NEEDS FIX"
fi

echo ""
echo "REPORT:"
echo "$(pwd)/$REPORT"

} | tee "$REPORT"
