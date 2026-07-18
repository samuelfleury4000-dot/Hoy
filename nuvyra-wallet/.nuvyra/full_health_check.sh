#!/usr/bin/env bash

echo "================================="
echo "       NUVYRA FULL HEALTH CHECK"
echo "================================="
date

echo ""
echo "===== DISQUE ====="
df -h

echo ""
echo "===== DOSSIERS LOURDS ====="
du -h --max-depth=1 2>/dev/null | sort -h | tail -15

echo ""
echo "===== SYSTEME ====="
node -v
npm -v

echo ""
echo "===== PROCESSUS NUVYRA ====="
ps aux | grep -E "guardian|vite|node" | grep -v grep || echo "Aucun processus trouvé"

echo ""
echo "===== NUVYRA STRUCTURE ====="
ls -la .nuvyra 2>/dev/null || echo ".nuvyra absente"

echo ""
echo "===== GUARDIAN ====="
if [ -f .nuvyra/logs/guardian.status ]; then
cat .nuvyra/logs/guardian.status
else
echo "Guardian pas encore initialisé"
fi

echo ""
echo "===== LOG GUARDIAN ====="
tail -20 .nuvyra/logs/guardian.log 2>/dev/null || echo "Pas de log"

echo ""
echo "===== NPM AUDIT ====="
npm audit --omit=dev 2>/dev/null || true

echo ""
echo "===== BUILD TEST ====="
npm run build

echo ""
echo "===== GIT ====="
git status --short

echo ""
echo "================================="
echo "       CHECK TERMINE"
echo "================================="
