#!/usr/bin/env bash

ROOT=$(pwd)
REPORT="$ROOT/.nuvyra/reports/AUDIT_$(date +%Y-%m-%d_%H-%M-%S).txt"

{

echo "=================================="
echo "NUVYRA AUTO AUDIT"
date
echo "=================================="

echo
echo "===== NODE ====="
node -v

echo
echo "===== NPM ====="
npm -v

echo
echo "===== DEPENDENCIES ====="
npm ls --depth=0 || true

echo
echo "===== SECURITY ====="
npm audit --omit=dev || true

echo
echo "===== BUILD ====="

if npm run build
then
echo
echo "✅ BUILD OK"
else
echo
echo "❌ BUILD FAILED"
fi

echo
echo "===== CONSOLE.LOG ====="
grep -R "console.log" src --line-number || true

echo
echo "===== TODO ====="
grep -R "TODO" src --line-number || true

echo
echo "===== FIXME ====="
grep -R "FIXME" src --line-number || true

echo
echo "===== API KEYS ====="
grep -R "apiKey\\|secret\\|token\\|privateKey" src --line-number || true

echo
echo "===== PASSWORDS ====="
grep -R "password" src --line-number || true

echo
echo "===== DUPLICATE IMPORTS ====="
grep -R "^import" src | sort | uniq -d || true

echo
echo "===== LARGE FILES ====="
find src -type f -exec du -h {} + | sort -h

echo
echo "===== GIT STATUS ====="
git status

echo
echo "=================================="
echo "FIN AUDIT"
echo "=================================="

} > "$REPORT" 2>&1

find "$ROOT/.nuvyra/reports" -type f -mmin +15 -delete

echo
echo "Rapport créé :"
echo "$REPORT"

