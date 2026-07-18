#!/bin/bash

REPORT_DIR="."

MAX_AGE=15

FILES=$(find "$REPORT_DIR" -maxdepth 1 \
-type f \
\( -name "*audit*" \
-o -name "*report*" \
-o -name "*security*" \
-o -name "*test*" \
-o -name "*HARDENING*" \
\) \
-mmin +$MAX_AGE)


if [ -n "$FILES" ]; then

echo "=== Nettoyage anciens rapports ==="

echo "$FILES"

echo "$FILES" | while read file
do
rm -f "$file"
done

echo "Rapports supprimés."

else

echo "Aucun ancien rapport à supprimer."

fi
