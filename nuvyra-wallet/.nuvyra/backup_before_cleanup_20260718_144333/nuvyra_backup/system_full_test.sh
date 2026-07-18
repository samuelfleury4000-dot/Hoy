#!/usr/bin/env bash

BASE=".nuvyra"
REPORT="$BASE/reports/system_full_test_$(date +%Y%m%d_%H%M%S).txt"

mkdir -p "$BASE/reports" "$BASE/logs"

{
echo "================================"
echo "      NUVYRA SYSTEM FULL TEST"
echo "================================"
date

echo ""
echo "===== STRUCTURE ====="
find .nuvyra -maxdepth 2 -type f | sort

echo ""
echo "===== PERMISSIONS ====="
find .nuvyra -name "*.sh" -exec ls -l {} \;

echo ""
echo "===== PROCESSES ====="
ps aux | grep -E "nuvyra|audit|guardian" | grep -v grep || echo "Aucun processus"

echo ""
echo "===== LOGS ====="
ls -lh .nuvyra/logs 2>/dev/null || echo "Logs absents"

echo ""
echo "===== REPORTS ====="
ls -lh .nuvyra/reports 2>/dev/null || echo "Reports absents"

echo ""
echo "===== DISK ====="
df -h

echo ""
echo "===== BUILD TEST ====="
npm run build

echo ""
echo "===== DEPENDENCIES ====="
npm audit --audit-level=high

echo ""
echo "===== GIT ====="
git status --short

echo ""
echo "===== GUARDIAN STATUS ====="
cat .nuvyra/logs/guardian.status 2>/dev/null || echo "Pas de status guardian"

echo ""
echo "===== ALERT STATUS ====="
cat .nuvyra/logs/alert.status 2>/dev/null || echo "Pas d'alerte"

echo ""
echo "================================"
echo " TEST TERMINE"
echo "================================"

} | tee "$REPORT"

echo ""
echo "Rapport créé:"
echo "$REPORT"

