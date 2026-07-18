#!/bin/bash

echo "===================================="
echo " NUVYRA HARDENING AUDIT"
date
echo "===================================="

echo ""
echo "===== 1. DEPENDENCY AUDIT ====="
npm audit

echo ""
echo "===== 2. BUILD TEST ====="
npm run build

echo ""
echo "===== 3. SEARCH SECURITY ISSUES ====="

grep -R "console.log" src || true

echo "--- exposed secrets ---"
grep -R "privateKey\|mnemonic\|seed\|password" src || true

echo "--- duplicate imports ---"
grep -R "import.*wallet" src || true


echo ""
echo "===== 4. FILE SIZE CHECK ====="

du -sh src
du -sh dist 2>/dev/null || true


echo ""
echo "===== 5. GIT STATUS ====="

git status


echo ""
echo "===================================="
echo " AUDIT NUVYRA TERMINE"
echo "===================================="

