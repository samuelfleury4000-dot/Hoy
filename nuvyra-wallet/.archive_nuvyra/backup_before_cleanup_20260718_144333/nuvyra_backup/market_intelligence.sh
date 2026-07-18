#!/bin/bash

REPORT=".nuvyra/reports/NUVYRA_MARKET_ANALYSIS.txt"
GRAPH=".nuvyra/reports/NUVYRA_MARKET_GRAPH.html"

mkdir -p .nuvyra/reports

DATE=$(date)

SRC=$(du -sh src 2>/dev/null | awk '{print $1}')
DIST=$(du -sh dist 2>/dev/null | awk '{print $1}')

FILES=$(find src -type f 2>/dev/null | wc -l)

FEATURES=0

grep -R "createRandom\|fromPhrase" src >/dev/null && FEATURES=$((FEATURES+1))
grep -R "sendTransaction" src >/dev/null && FEATURES=$((FEATURES+1))
grep -R "Contract" src >/dev/null && FEATURES=$((FEATURES+1))
grep -R "QRCode\|qrcode" src >/dev/null && FEATURES=$((FEATURES+1))
grep -R "history" src >/dev/null && FEATURES=$((FEATURES+1))
grep -R "network" src >/dev/null && FEATURES=$((FEATURES+1))

SECURITY=0
grep -R "encrypt" src >/dev/null && SECURITY=$((SECURITY+10))
grep -R "fromEncryptedJson" src >/dev/null && SECURITY=$((SECURITY+10))

TECH=0

[ -d dist ] && TECH=$((TECH+10))
[ $FILES -gt 10 ] && TECH=$((TECH+5))
[ $FEATURES -gt 3 ] && TECH=$((TECH+5))

PRODUCT=$((FEATURES*3))
[ $PRODUCT -gt 20 ] && PRODUCT=20

UX=10
[ $FILES -gt 15 ] && UX=15

MARKET=$((PRODUCT/2+UX))

TOTAL=$((TECH+SECURITY+PRODUCT+UX+MARKET))

if [ $TOTAL -gt 100 ]; then
TOTAL=100
fi


cat > "$REPORT" <<REPORT
================================
 NUVYRA MARKET INTELLIGENCE
================================

DATE:
$DATE


PROJECT ANALYSIS

SOURCE SIZE:
$SRC

BUILD SIZE:
$DIST

SOURCE FILES:
$FILES


==============================
SCORES
==============================

TECH QUALITY:
$TECH /20

SECURITY TRUST:
$SECURITY /20

PRODUCT FEATURES:
$PRODUCT /20

USER EXPERIENCE:
$UX /15

MARKET POTENTIAL:
$MARKET /25


==============================
FINAL SCORE
==============================

$TOTAL /100


==============================
AI RECOMMENDATIONS
==============================

REPORT ENGINE:

$(

if [ $PRODUCT -lt 15 ]; then
echo "- Ajouter plus de fonctionnalités visibles utilisateur"
else
echo "- Fonctionnalités principales solides"
fi

if [ $SECURITY -ge 20 ]; then
echo "- Niveau confiance wallet élevé"
else
echo "- Renforcer sécurité avant lancement"
fi

if [ $UX -lt 15 ]; then
echo "- Simplifier onboarding utilisateur"
else
echo "- UX acceptable"
fi

)

==============================

RISQUE LANCEMENT:

$(

if [ $TOTAL -ge 80 ]; then
echo "🟢 Fort potentiel"
elif [ $TOTAL -ge 60 ]; then
echo "🟡 Potentiel moyen, optimisation nécessaire"
else
echo "🔴 Risque élevé"
fi

)

================================
