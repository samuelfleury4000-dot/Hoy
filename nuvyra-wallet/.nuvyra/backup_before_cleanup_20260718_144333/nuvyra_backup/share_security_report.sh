#!/bin/bash

OUT=".nuvyra/reports/security_share_report.txt"

mkdir -p .nuvyra/reports

{
echo "================================"
echo " NUVYRA SECURITY SHARE REPORT"
echo "================================"
date

echo
echo "===== PRIVATE KEY SCAN ====="
grep -R -nE "0x[a-fA-F0-9]{64}|PRIVATE_KEY|privateKey|BEGIN PRIVATE|SECRET_KEY" . \
--exclude-dir=node_modules \
--exclude-dir=dist \
--exclude-dir=.git 2>/dev/null || echo "CLEAN"

echo
echo "===== SEED / MNEMONIC ====="
grep -R -nE "mnemonic|seed|fromPhrase|wallet\.mnemonic" src \
2>/dev/null || echo "NONE"

echo
echo "===== ENV CHECK ====="
grep -R -nE "API|KEY|SECRET|PASSWORD" .env src \
2>/dev/null || echo "CLEAN"

echo
echo "===== WALLET SECURITY ====="
grep -R -nE "encrypt|fromEncryptedJson|createRandom|sendTransaction" src/lib \
2>/dev/null || echo "NONE"

echo
echo "================================"
echo "END REPORT"
echo "================================"

} | tee "$OUT"

echo
echo "Rapport créé : $OUT"
