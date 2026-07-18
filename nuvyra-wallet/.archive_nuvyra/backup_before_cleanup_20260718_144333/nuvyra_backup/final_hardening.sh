#!/bin/bash

echo "NUVYRA FINAL HARDENING"

mkdir -p .nuvyra/archive_final

# Archiver anciens audits
mv .nuvyra/archive_old_audits .nuvyra/archive_final/ 2>/dev/null
mv .nuvyra/archive_cleanup_* .nuvyra/archive_final/ 2>/dev/null

# Nettoyage rapports vieux
find .nuvyra/reports -type f -mtime +7 -delete 2>/dev/null

# Permissions sécurité
find .nuvyra -type f -name "*.sh" -exec chmod 700 {} \;

# Logs protégés
chmod 600 .nuvyra/logs/* 2>/dev/null

# Protection env
chmod 600 .env 2>/dev/null

# Stop doublons daemon
pkill -f ".nuvyra/alert_monitor.sh" 2>/dev/null
pkill -f ".nuvyra/nuvyra_daemon.sh" 2>/dev/null

# Redémarrage monitoring propre
nohup bash .nuvyra/nuvyra_daemon.sh >/dev/null 2>&1 &
nohup bash .nuvyra/alert_monitor.sh >/dev/null 2>&1 &

# Git ignore sécurité
cat >> .gitignore <<'GIT'

.env
.nuvyra/logs/
.nuvyra/archive*/
dist/
node_modules/

GIT

echo "HARDENING COMPLETE"
echo "SYSTEM READY"
