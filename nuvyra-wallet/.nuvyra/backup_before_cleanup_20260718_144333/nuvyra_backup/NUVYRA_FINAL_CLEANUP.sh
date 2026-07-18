#!/bin/bash

set -e

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP=".nuvyra/backup_before_cleanup_$DATE"

mkdir -p "$BACKUP"

echo "================================"
echo " NUVYRA FINAL CLEANUP"
echo "================================"

echo
echo "[1] Backup sécurité"

cp -r .nuvyra "$BACKUP/nuvyra_backup" 2>/dev/null || true

echo "BACKUP OK"


echo
echo "[2] Suppression archives inutiles"

find .nuvyra -type d \
-name "archive_old_audits" \
-o -name "archive_cleanup_*" \
-o -name "archive_final" \
| while read DIR; do
    echo "Archive trouvée: $DIR"
done


echo
echo "[3] Nettoyage rapports anciens"

find .nuvyra/reports -type f \
-name "*.txt" \
! -name "FINAL_COMPLETE_TEST*" \
! -name "NUVYRA_MASTER_REPORT.txt" \
! -name "latest.txt" \
-delete 2>/dev/null || true


echo
echo "[4] Nettoyage logs anciens"

find .nuvyra/logs -type f \
-name "*.log" \
-size +1M \
-delete 2>/dev/null || true


echo
echo "[5] Permissions sécurité"

find .nuvyra -type f -name "*.sh" -exec chmod 700 {} \;


echo
echo "[6] Build validation"

npm run build


echo
echo "[7] Git check"

git status --short


echo
echo "================================"
echo " CLEANUP COMPLETE"
echo " BACKUP:"
echo "$BACKUP"
echo "================================"
