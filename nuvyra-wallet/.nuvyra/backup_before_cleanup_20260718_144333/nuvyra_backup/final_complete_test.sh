#!/bin/bash

REPORT=".nuvyra/reports/FINAL_COMPLETE_TEST_$(date +%Y%m%d_%H%M%S).txt"

mkdir -p .nuvyra/reports
touch "$REPORT"

exec > >(tee "$REPORT") 2>&1

echo "================================"
echo "      NUVYRA FINAL COMPLETE TEST"
echo "================================"
date

echo ""
echo "===== SYSTEM ====="
node -v
npm -v

echo ""
echo "===== PROJECT STRUCTURE ====="
find src -maxdepth 3 -type f | sort

echo ""
echo "===== DEPENDENCIES ====="
npm audit --omit=dev || true

echo ""
echo "===== INSTALL CHECK ====="
npm ls --depth=0

echo ""
echo "===== BUILD TEST ====="
npm run build

if [ $? -eq 0 ]; then
 echo "BUILD STATUS: OK"
else
 echo "BUILD STATUS: FAILED"
fi

echo ""
echo "===== WALLET SECURITY ====="

grep -RInE \
"PRIVATE_KEY|privateKey|BEGIN PRIVATE|SECRET_KEY|0x[a-fA-F0-9]{64}" \
src .env 2>/dev/null || echo "NO PRIVATE SECRET FOUND"

echo ""
echo "===== SEED HANDLING ====="

grep -RInE \
"mnemonic|seed|phrase|Wallet.createRandom|fromPhrase|encrypt" \
src 2>/dev/null || echo "NO WALLET LOGIC FOUND"

echo ""
echo "===== ENV CHECK ====="

if [ -f .env ]; then
 echo ".env detected"
 grep -E "API|KEY|SECRET" .env
else
 echo "NO ENV FILE"
fi

echo ""
echo "===== BLOCKCHAIN CHECK ====="

grep -RInE \
"JsonRpcProvider|sendTransaction|Contract" \
src/lib 2>/dev/null || echo "NO BLOCKCHAIN MODULE"

echo ""
echo "===== PERFORMANCE ====="

du -sh src
du -sh dist 2>/dev/null || echo "NO DIST"

echo ""
echo "===== DISK ====="

df -h

echo ""
echo "===== PERMISSIONS ====="

find .nuvyra -type f -name "*.sh" -exec ls -l {} \;

echo ""
echo "===== GIT STATUS ====="

git status --short

echo ""
echo "===== SECURITY FILES ====="

find .nuvyra -type f | sort

echo ""
echo "===== LOG HEALTH ====="

ls -lh .nuvyra/logs 2>/dev/null

echo ""
echo "===== FINAL SCORE ====="

if npm run build >/dev/null 2>&1; then
 echo "BUILD: PASS"
else
 echo "BUILD: FAIL"
fi

if grep -RInE "0x[a-fA-F0-9]{64}|BEGIN PRIVATE" src .env >/dev/null 2>&1; then
 echo "PRIVATE KEY: WARNING"
else
 echo "PRIVATE KEY: CLEAN"
fi

echo ""
echo "================================"
echo " FINAL TEST COMPLETE"
echo " REPORT:"
echo "$REPORT"
echo "================================"
