#!/bin/bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE="$ROOT/.nuvyra/archive_sh"
REPORT="$ROOT/.nuvyra/reports/SCRIPT_CLEANUP_REPORT.txt"

mkdir -p "$ARCHIVE"
mkdir -p "$ROOT/.nuvyra/reports"

echo "===== NUVYRA SCRIPT CLEANUP =====" > "$REPORT"
date >> "$REPORT"

PATTERN="guardian|health_score|security_scan|predeploy|daemon|monitor"

echo "" >> "$REPORT"
echo "Scripts détectés :" >> "$REPORT"

find "$ROOT/.nuvyra" \
-type f \
-name "*.sh" \
-not -path "*/archive_*/*" \
-not -path "*/checks/*" \
-not -path "*/core/*" \
-not -name "engine.sh" \
| grep -Ei "$PATTERN" >> "$REPORT"

echo "" >> "$REPORT"
echo "Archivage..." >> "$REPORT"

find "$ROOT/.nuvyra" \
-type f \
-name "*.sh" \
-not -path "*/archive_*/*" \
-not -path "*/checks/*" \
-not -path "*/core/*" \
-not -name "engine.sh" \
| grep -Ei "$PATTERN" \
| while read file; do
    mv "$file" "$ARCHIVE/"
done

echo "PASS: anciens scripts archivés" >> "$REPORT"

echo ""
cat "$REPORT"
