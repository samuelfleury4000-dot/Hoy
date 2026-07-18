#!/bin/bash

FILE="src/lib/config.js"

echo "===== API SECURITY ====="

if grep -q "VITE_MOONPAY_API_KEY" "$FILE"; then

VALUE=$(grep "VITE_MOONPAY_API_KEY" .env 2>/dev/null)

if echo "$VALUE" | grep -q "pk_test\|pk_live"; then
echo "🟢 INFO : clé publique MoonPay détectée"
echo "Frontend compatible"
else
echo "🔴 CRITICAL : clé API suspecte"
fi

else
echo "OK : aucune API frontend"
fi
