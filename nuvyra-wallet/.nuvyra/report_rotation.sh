#!/bin/bash
REPORT=".nuvyra/reports"
ARCHIVE="$REPORT/archive"
mkdir -p "$ARCHIVE"

# garder seulement les 10 derniers rapports
ls -1t "$REPORT"/*.txt 2>/dev/null | tail -n +11 | while read f; do
mv "$f" "$ARCHIVE/"
done

# nettoyer archives trop vieilles
find "$ARCHIVE" -type f -mtime +30 -delete

echo "NUVYRA REPORT ROTATION CLEAN"
date
