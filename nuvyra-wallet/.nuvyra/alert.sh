#!/bin/bash
if grep -Ei "FAILED|ERROR|erreur|vulnerability" .nuvyra/reports/latest.txt >/dev/null; then
echo "⚠️ NUVYRA ALERTE : problème détecté"
else
echo "OK : aucun problème détecté"
fi
