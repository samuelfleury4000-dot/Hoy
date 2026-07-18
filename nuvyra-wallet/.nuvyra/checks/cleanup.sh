#!/bin/bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE="$ROOT/.nuvyra/archive_txt"
REPORT="$ROOT/.nuvyra/reports/ENGINE_REPORT.txt"

mkdir -p "$ARCHIVE"

echo "" >> "$REPORT"
echo "===== CLEANUP =====" >> "$REPORT"

COUNT=$(find "$ROOT" -type f -name "*.txt" \
-not -path "*/node_modules/*" \
-not -path "*/dist/*" \
-not -path "*/.git/*" \
-not -path "*/.nuvyra/reports/*" \
-not -path "*/.nuvyra/archive_txt/*" | wc -l)

if [ "$COUNT" -gt 0 ]; then
    find "$ROOT" -type f -name "*.txt" \
    -not -path "*/node_modules/*" \
    -not -path "*/dist/*" \
    -not -path "*/.git/*" \
    -not -path "*/.nuvyra/reports/*" \
    -not -path "*/.nuvyra/archive_txt/*" \
    -exec mv {} "$ARCHIVE/" \;

    echo "PASS: $COUNT fichiers TXT archivés" >> "$REPORT"
else
    echo "PASS: Aucun TXT inutile trouvé" >> "$REPORT"
fi
