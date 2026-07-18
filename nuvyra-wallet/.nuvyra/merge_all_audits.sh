#!/usr/bin/env bash

REPORT_DIR=".nuvyra/reports"
FINAL="$REPORT_DIR/NUVYRA_AUDIT_FINAL.txt"

mkdir -p "$REPORT_DIR"


TEMP=$(mktemp)


echo "========================================" > "$TEMP"
echo "          NUVYRA MASTER AUDIT" >> "$TEMP"
echo "========================================" >> "$TEMP"
echo "Date : $(date)" >> "$TEMP"
echo "" >> "$TEMP"


echo "===== RÉSUMÉ AUTOMATIQUE =====" >> "$TEMP"
echo "" >> "$TEMP"


ERRORS=$(grep -RIn \
"ERROR\|FAILED\|FAIL\|CRITICAL" \
"$REPORT_DIR" \
2>/dev/null | wc -l)


WARNINGS=$(grep -RIn \
"WARNING\|WARN\|⚠️" \
"$REPORT_DIR" \
2>/dev/null | wc -l)


OK=$(grep -RIn \
"OK\|SUCCESS\|✅" \
"$REPORT_DIR" \
2>/dev/null | wc -l)



echo "🔴 Erreurs : $ERRORS" >> "$TEMP"
echo "🟠 Alertes : $WARNINGS" >> "$TEMP"
echo "🟢 Validations : $OK" >> "$TEMP"
echo "" >> "$TEMP"



echo "===== TOUS LES AUDITS =====" >> "$TEMP"
echo "" >> "$TEMP"



for FILE in "$REPORT_DIR"/*.txt
do

NAME=$(basename "$FILE")


if [ "$FILE" != "$FINAL" ]
then

echo "----------------------------------------" >> "$TEMP"
echo "AUDIT : $NAME" >> "$TEMP"
echo "----------------------------------------" >> "$TEMP"

cat "$FILE" >> "$TEMP"

echo "" >> "$TEMP"

fi

done



echo "========================================" >> "$TEMP"
echo "FIN AUDIT GLOBAL" >> "$TEMP"
echo "========================================" >> "$TEMP"



mv "$TEMP" "$FINAL"



# suppression rapports secondaires
find "$REPORT_DIR" \
-type f \
-name "*.txt" \
! -name "NUVYRA_AUDIT_FINAL.txt" \
-delete



echo "Rapport unique créé : $FINAL"

