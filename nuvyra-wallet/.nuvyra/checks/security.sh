#!/usr/bin/env bash

REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT_FINAL.txt}"

echo ""
echo "SECURITY PRO AUDIT"
echo "------------------"


CRITICAL=0
WARNING=0
INFO=0


echo "" >> "$REPORT"
echo "===== SECURITY PRO =====" >> "$REPORT"



# Vrais secrets possibles

echo "" >> "$REPORT"
echo "[SECRETS]" >> "$REPORT"


SECRET=$(grep -RInE \
"(0x[a-fA-F0-9]{64}|-----BEGIN PRIVATE KEY-----|AKIA[0-9A-Z]{16}|sk_live_|api[_-]?key\s*=|private[_-]?key\s*=)" \
src \
--exclude-dir=node_modules \
2>/dev/null)



if [ -n "$SECRET" ]
then

echo "🔴 Secrets potentiels trouvés:" >> "$REPORT"
echo "$SECRET" >> "$REPORT"

CRITICAL=$((CRITICAL+1))

else

echo "🟢 Aucun secret exposé détecté" >> "$REPORT"

fi




# Wallet security


echo "" >> "$REPORT"
echo "[WALLET SECURITY]" >> "$REPORT"



if grep -RIn "localStorage" src/lib src/components >/dev/null 2>&1
then

echo "🟠 Wallet utilise localStorage (risque XSS à surveiller)" >> "$REPORT"

WARNING=$((WARNING+1))

else

echo "🟢 Aucun stockage navigateur détecté" >> "$REPORT"

fi




if grep -RIn "mnemonic\|seed\|privateKey" src >/dev/null 2>&1
then

echo "🟠 Manipulation de données sensibles détectée (vérification requise)" >> "$REPORT"

WARNING=$((WARNING+1))

else

echo "🟢 Pas de données sensibles visibles" >> "$REPORT"

fi




# Transactions


echo "" >> "$REPORT"
echo "[TRANSACTIONS]" >> "$REPORT"



if grep -RIn "sendTransaction" src >/dev/null 2>&1
then

echo "🟢 Envoi transaction détecté" >> "$REPORT"

else

echo "ℹ️ Aucun module transaction trouvé" >> "$REPORT"

INFO=$((INFO+1))

fi




# Environment


echo "" >> "$REPORT"
echo "[ENVIRONMENT]" >> "$REPORT"



if [ -f ".env" ]
then

echo "🟠 Fichier .env présent, vérifier avant déploiement" >> "$REPORT"

WARNING=$((WARNING+1))

else

echo "🟢 Aucun .env local détecté" >> "$REPORT"

fi




# Permissions


echo "" >> "$REPORT"
echo "[FILES PERMISSIONS]" >> "$REPORT"



BAD=$(find . \
-name "*.key" \
-o -name "*.pem" \
-o -name "*.secret" \
2>/dev/null)



if [ -n "$BAD" ]
then

echo "🔴 Fichiers sensibles trouvés:" >> "$REPORT"
echo "$BAD" >> "$REPORT"

CRITICAL=$((CRITICAL+1))

else

echo "🟢 Aucun fichier sensible trouvé" >> "$REPORT"

fi




echo "" >> "$REPORT"
echo "[SECURITY SCORE]" >> "$REPORT"

SEC_SCORE=$((100-(CRITICAL*25)-(WARNING*5)))

if [ "$SEC_SCORE" -lt 0 ]
then
SEC_SCORE=0
fi


echo "Critiques : $CRITICAL" >> "$REPORT"
echo "Alertes : $WARNING" >> "$REPORT"
echo "Infos : $INFO" >> "$REPORT"
echo "Security score : $SEC_SCORE / 100" >> "$REPORT"

