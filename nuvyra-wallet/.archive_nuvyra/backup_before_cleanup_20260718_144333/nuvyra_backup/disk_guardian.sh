#!/usr/bin/env bash

LIMIT=90
USAGE=$(df /workspaces -P | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ "$USAGE" -ge "$LIMIT" ]; then
echo "ALERTE DISQUE: ${USAGE}% utilisé"

find .nuvyra/logs -type f -mtime +3 -delete 2>/dev/null
find .nuvyra/backups -type f -mtime +3 -delete 2>/dev/null
npm cache clean --force 2>/dev/null || true

fi
