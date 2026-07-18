#!/usr/bin/env bash

BASE=".nuvyra"
STATE="$BASE/logs/audit_perfect_state"
LOG="$BASE/logs/audit_stability.log"

mkdir -p "$BASE/logs"

PASS=0

for i in {1..3}
do

echo "Test stabilité $i/3" >> "$LOG"

bash .nuvyra/audit_self_optimizer.sh >/dev/null 2>&1

if grep -q "système stable et optimisé" "$BASE/logs/audit_status"
then
PASS=$((PASS+1))
fi

sleep 2

done


if [ "$PASS" -eq 3 ]
then

echo "NUVYRA AUDIT PERFECT - 3 validations consécutives" > "$STATE"

echo "🔔 NUVYRA : AUDITS PARFAITS ET STABLES"

else

echo "NUVYRA : stabilité non confirmée" > "$STATE"

echo "⚠️ NUVYRA : vérifier les audits"

fi
