#!/bin/bash

REPORT=".nuvyra/reports/NUVYRA_HEALTH_SCORE.txt"

mkdir -p .nuvyra/reports

SCORE=100
CRITICAL=0
WARNING=0
INFO=0

echo "================================" > $REPORT
echo "       NUVYRA HEALTH SCORE" >> $REPORT
echo "================================" >> $REPORT
echo "DATE: $(date)" >> $REPORT
echo "" >> $REPORT

echo "===== SECURITY =====" >> $REPORT

if grep -RInE "0x[a-fA-F0-9]{64}|PRIVATE_KEY|SECRET_KEY|BEGIN PRIVATE" src .env 2>/dev/null; then
    SCORE=$((SCORE-40))
    CRITICAL=$((CRITICAL+1))
    echo "CRITICAL: Secret potentiel détecté" >> $REPORT
else
    echo "PASS: Aucun secret privé trouvé" >> $REPORT
fi

echo "" >> $REPORT
echo "===== ENVIRONMENT =====" >> $REPORT

if [ -f ".env" ]; then
    echo "INFO: fichier .env présent" >> $REPORT
    INFO=$((INFO+1))
else
    echo "PASS: aucun .env local" >> $REPORT
fi

echo "" >> $REPORT
echo "===== DEPENDENCIES =====" >> $REPORT

if npm audit --audit-level=high >/dev/null 2>&1; then
    echo "PASS: Dépendances propres" >> $REPORT
else
    SCORE=$((SCORE-20))
    WARNING=$((WARNING+1))
    echo "WARNING: Vulnérabilités npm détectées" >> $REPORT
fi

echo "" >> $REPORT
echo "===== BUILD =====" >> $REPORT

if npm run build >/dev/null 2>&1; then
    echo "PASS: Build réussi" >> $REPORT
else
    SCORE=$((SCORE-30))
    CRITICAL=$((CRITICAL+1))
    echo "CRITICAL: Build échoué" >> $REPORT
fi

echo "" >> $REPORT
echo "===== STORAGE =====" >> $REPORT

DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK" -gt 90 ]; then
    SCORE=$((SCORE-10))
    WARNING=$((WARNING+1))
    echo "WARNING: Disque presque plein ($DISK%)" >> $REPORT
else
    echo "PASS: Stockage normal ($DISK%)" >> $REPORT
fi

echo "" >> $REPORT
echo "================================" >> $REPORT
echo " SCORE FINAL: $SCORE/100" >> $REPORT
echo " CRITICAL: $CRITICAL" >> $REPORT
echo " WARNING: $WARNING" >> $REPORT
echo " INFO: $INFO" >> $REPORT

if [ "$SCORE" -ge 90 ]; then
    echo "STATUS: 🟢 EXCELLENT" >> $REPORT
elif [ "$SCORE" -ge 70 ]; then
    echo "STATUS: 🟡 GOOD" >> $REPORT
else
    echo "STATUS: 🔴 NEEDS FIX" >> $REPORT
fi

echo "================================" >> $REPORT

cat $REPORT
