#!/usr/bin/env bash

OUTPUT="NUVYRA_SOURCE_IMPORTANT.txt"

rm -f "$OUTPUT"

echo "=================================" >> "$OUTPUT"
echo "       NUVYRA SOURCE CLEAN" >> "$OUTPUT"
echo "=================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

FILES=$(find . \
-type f \
\( \
-name "*.js" \
-o -name "*.jsx" \
-o -name "*.ts" \
-o -name "*.tsx" \
-o -name "*.css" \
-o -name "*.html" \
-o -name "*.json" \
-o -name "*.sh" \
-o -name "*.env.example" \
\) \
! -path "./node_modules/*" \
! -path "./dist/*" \
! -path "./.git/*" \
! -path "./.nuvyra/logs/*" \
! -path "./.nuvyra/backups/*" \
)

for FILE in $FILES
do
    echo "=================================" >> "$OUTPUT"
    echo "FILE: $FILE" >> "$OUTPUT"
    echo "=================================" >> "$OUTPUT"
    cat "$FILE" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
done

echo "Export terminé : $OUTPUT"
