#!/usr/bin/env bash

set -u

BASE=".nuvyra"
LOG="$BASE/logs/guardian.log"
STATE="$BASE/logs/guardian.status"
LOCK="$BASE/logs/AUDIT_BLOCKED"

REPORT_DIR="$BASE/reports"

MAX_ERRORS=20
MAX_SIZE_MB=10

mkdir -p "$BASE/logs"


log(){
echo "[$(date '+%F %T')] $1" | tee -a "$LOG"
}


check_reports(){

if [ ! -d "$REPORT_DIR" ]
then
echo "0"
return
fi

ERRORS=$(grep -RInE \
"ERROR|FAILED|syntax error|MODULE MANQUANT|CRITICAL|Exception" \
"$REPORT_DIR" \
2>/dev/null | wc -l)

echo "$ERRORS"
}


check_report_size(){

SIZE=$(du -sm "$REPORT_DIR" 2>/dev/null | awk '{print $1}')

echo "${SIZE:-0}"

}


stop_audit(){

log "🚨 AFFOLEMENT DETECTE"

touch "$LOCK"

echo "BLOCKED" > "$STATE"

pkill -f auto_audit_daemon.sh 2>/dev/null || true
pkill -f runner.sh 2>/dev/null || true

log "Audit automatique stoppé"

}


recover(){

if [ -f "$LOCK" ]
then

ERRORS=$(check_reports)

if [ "$ERRORS" -eq 0 ]
then

rm "$LOCK"

echo "RUNNING" > "$STATE"

log "✅ Système stabilisé, audit débloqué"

fi

fi

}



log "=== NUVYRA AUDIT GUARDIAN START ==="


while true
do


ERRORS=$(check_reports)

SIZE=$(check_report_size)


log "Etat: erreurs=$ERRORS taille=${SIZE}MB"


if [ "$ERRORS" -ge "$MAX_ERRORS" ]
then

stop_audit

fi


if [ "$SIZE" -ge "$MAX_SIZE_MB" ]
then

log "Rapports trop volumineux"

stop_audit

fi


recover


if [ -f "$LOCK" ]
then
echo "🔴 AUDIT BLOQUÉ - intervention nécessaire"
else
echo "🟢 AUDIT NORMAL - erreurs: $ERRORS"
fi


sleep 60


done

