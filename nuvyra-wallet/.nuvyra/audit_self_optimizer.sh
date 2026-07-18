#!/usr/bin/env bash

BASE=".nuvyra"
LOG="$BASE/logs/audit_optimizer.log"
STATE="$BASE/logs/audit_status"

mkdir -p "$BASE/logs" "$BASE/backups"

echo "================================" > "$LOG"
echo " NUVYRA AUDIT SELF OPTIMIZER" >> "$LOG"
echo "$(date)" >> "$LOG"
echo "================================" >> "$LOG"


backup_audit(){

BACKUP="$BASE/backups/audit_fix_$(date +%Y%m%d_%H%M%S).tar.gz"

tar \
--exclude="$BASE/backups" \
-czf "$BACKUP" "$BASE" \
2>/dev/null || true

echo "Backup audit : $BACKUP" >> "$LOG"

}



check_internal_errors(){

grep -RInE \
"syntax error|>>>|MODULE MANQUANT|command not found" \
.nuvyra/modules \
--include="*.sh" \
2>/dev/null || true

}



fix_internal_only(){

echo "Correction audit interne..." >> "$LOG"


# Corrige seulement les scripts audit

find "$BASE" \
-name "*.sh" \
-exec sed -i 's/>>/>>/g' {} \;



# Permissions scripts

find "$BASE" \
-name "*.sh" \
-exec chmod +x {} \;



echo "Correction terminée" >> "$LOG"

}



notify(){

MESSAGE="NUVYRA AUDIT : système stable et optimisé"

echo "$MESSAGE" > "$STATE"

echo "🔔 $MESSAGE"

}



PASS=1
MAX=5


while [ "$PASS" -le "$MAX" ]

do

echo "" >> "$LOG"
echo "===== PASS $PASS/$MAX =====" >> "$LOG"


backup_audit


ERRORS=$(check_internal_errors | wc -l)



if [ "$ERRORS" -eq 0 ]
then

notify
break

fi



echo "Problèmes internes trouvés : $ERRORS" >> "$LOG"


fix_internal_only


PASS=$((PASS+1))


done



echo ""
echo "Optimisation terminée"
echo "Log : $LOG"

