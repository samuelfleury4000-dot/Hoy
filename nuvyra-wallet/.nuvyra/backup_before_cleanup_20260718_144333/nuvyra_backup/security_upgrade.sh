#!/bin/bash

REPORT=".nuvyra/reports/security_report.txt"
mkdir -p .nuvyra/reports .nuvyra/logs

{
echo "================================"
echo "     NUVYRA SECURITY AUDIT v2"
echo "================================"
date

echo
echo "===== CRITICAL SCAN ====="

CRITICAL=$(grep -R -nE \
"PRIVATE_KEY|BEGIN PRIVATE|0x[a-fA-F0-9]{64}|SECRET_KEY|password[[:space:]]*=[[:space:]]*['\"]" \
src .env 2>/dev/null)

if [ -n "$CRITICAL" ]; then
echo "🔴 CRITICAL : secret potentiel trouvé"
echo "$CRITICAL"
else
echo "OK : aucune clé privée ou secret hardcodé"
fi


echo
echo "===== MNEMONIC CHECK ====="

MNEMONIC=$(grep -R -nE \
"wallet\.mnemonic\.phrase|fromPhrase|mnemonic" \
src/lib src/components 2>/dev/null)

if [ -n "$MNEMONIC" ]; then
echo "🟢 INFO : gestion seed détectée"
echo "Raison : génération/import wallet normale"
echo "$MNEMONIC"
fi


echo
echo "===== API KEY CHECK ====="

API=$(grep -R -nE \
"VITE_.*API|API_KEY" \
src .env 2>/dev/null)

if [ -n "$API" ]; then
echo "🟠 WARNING : clé API frontend détectée"
echo "Vérifier qu'elle est publique uniquement"
echo "$API"
else
echo "OK : aucune API détectée"
fi


echo
echo "===== WALLET PROTECTION ====="

if grep -R "encrypt(password)" src/lib >/dev/null; then
echo "OK : wallet chiffré"
else
echo "🟠 WARNING : chiffrement absent"
fi

if grep -R "fromEncryptedJson" src/lib >/dev/null; then
echo "OK : restauration keystore présente"
else
echo "🟠 WARNING : restauration absente"
fi


echo
echo "===== REPORT STATUS ====="

if [ -n "$CRITICAL" ]; then
echo "STATUS : ACTION REQUIRED"
else
echo "STATUS : CLEAN"
fi

echo
echo "================================"
echo "AUDIT FINI"
echo "================================"

} | tee "$REPORT"

