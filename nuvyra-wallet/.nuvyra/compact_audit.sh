#!/usr/bin/env bash

REPORT=".nuvyra/reports/NUVYRA_AUDIT.txt"

mkdir -p .nuvyra/reports


echo "================================" > "$REPORT"
echo "        NUVYRA AUDIT" >> "$REPORT"
echo "================================" >> "$REPORT"
echo "Date: $(date)" >> "$REPORT"
echo "" >> "$REPORT"



SCORE=100



echo "BUILD" >> "$REPORT"
echo "-----" >> "$REPORT"

if npm run build >/dev/null 2>&1
then
echo "✅ Build OK" >> "$REPORT"
else
echo "❌ Build FAILED" >> "$REPORT"
SCORE=$((SCORE-25))
fi



echo "" >> "$REPORT"
echo "SECURITY" >> "$REPORT"
echo "---------" >> "$REPORT"


SECRETS=$(grep -RInE \
"PRIVATE_KEY|API_KEY|SECRET|mnemonic|seed" \
src \
2>/dev/null | wc -l)


if [ "$SECRETS" -eq 0 ]
then
echo "✅ Aucun secret évident" >> "$REPORT"
else
echo "⚠️ $SECRETS éléments sensibles trouvés à vérifier" >> "$REPORT"
SCORE=$((SCORE-10))
fi



echo "" >> "$REPORT"
echo "CODE QUALITY" >> "$REPORT"
echo "------------" >> "$REPORT"


TODO=$(grep -RIn \
"TODO\|FIXME" \
src \
2>/dev/null | wc -l)


if [ "$TODO" -eq 0 ]
then
echo "✅ Pas de TODO" >> "$REPORT"
else
echo "⚠️ $TODO TODO/FIXME" >> "$REPORT"
SCORE=$((SCORE-5))
fi



ERRORS=$(grep -RIn \
"console.log" \
src \
2>/dev/null | wc -l)


echo "Console.log: $ERRORS" >> "$REPORT"



echo "" >> "$REPORT"
echo "BLOCKCHAIN" >> "$REPORT"
echo "----------" >> "$REPORT"


if curl -s https://rpc.sepolia.org \
| grep -q json
then
echo "✅ RPC Sepolia accessible" >> "$REPORT"
else
echo "⚠️ RPC non vérifié" >> "$REPORT"
SCORE=$((SCORE-5))
fi



echo "" >> "$REPORT"
echo "PERFORMANCE" >> "$REPORT"
echo "-----------" >> "$REPORT"


if [ -d dist ]
then

SIZE=$(du -sh dist | awk '{print $1}')

echo "Bundle: $SIZE" >> "$REPORT"

else

echo "⚠️ Dist absent" >> "$REPORT"

fi



if [ "$SCORE" -lt 0 ]
then
SCORE=0
fi


echo "" >> "$REPORT"
echo "================================" >> "$REPORT"
echo "SCORE FINAL : $SCORE / 100" >> "$REPORT"
echo "================================" >> "$REPORT"



echo "Rapport unique créé:"
echo "$REPORT"

