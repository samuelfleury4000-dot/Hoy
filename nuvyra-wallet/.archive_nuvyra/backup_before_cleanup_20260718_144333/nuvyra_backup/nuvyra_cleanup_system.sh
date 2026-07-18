#!/bin/bash

set -e

echo "================================"
echo " NUVYRA AUDIT SYSTEM CLEANUP"
echo "================================"

BASE=".nuvyra"
ARCHIVE="$BASE/archive_cleanup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$ARCHIVE"

echo "[1/5] Archivage anciens audits..."

for f in \
audit_guardian.sh \
auto_audit_daemon.sh \
compact_audit.sh \
fix_audit_system.sh \
full_audit.sh \
audit.sh \
scripts
do
    if [ -e "$BASE/$f" ]; then
        mv "$BASE/$f" "$ARCHIVE/" || true
    fi
done


echo "[2/5] Conservation système principal..."

KEEP="
nuvyra_master_audit.sh
nuvyra_complete_guardian.sh
read_only_guardian.sh
nuvyra_daemon.sh
alert_monitor.sh
cleanup_reports.sh
health_score.sh
security_clean.sh
system_full_test.sh
"


echo "[3/5] Nettoyage rapports temporaires..."

find "$BASE/reports" -type f \
-name "system_full_test_*" \
-mtime +1 \
-delete 2>/dev/null || true


echo "[4/5] Nettoyage logs volumineux..."

find "$BASE/logs" -type f \
-size +1M \
-delete 2>/dev/null || true


echo "[5/5] Etat final..."

echo "MASTER AUDIT:"
echo " - $BASE/nuvyra_master_audit.sh"

echo "GUARDIAN:"
echo " - $BASE/nuvyra_complete_guardian.sh"

echo "DAEMON:"
echo " - $BASE/nuvyra_daemon.sh"

echo "ALERT:"
echo " - $BASE/alert_monitor.sh"


echo
echo "================================"
echo " CLEANUP TERMINE"
echo "================================"

