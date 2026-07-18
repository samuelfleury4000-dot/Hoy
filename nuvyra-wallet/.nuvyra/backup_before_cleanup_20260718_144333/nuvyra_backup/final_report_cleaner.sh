#!/usr/bin/env bash

REPORT_DIR=".nuvyra/reports"
FINAL="$REPORT_DIR/NUVYRA_AUDIT_FINAL.txt"

mkdir -p "$REPORT_DIR"


echo "==================================" > "$FINAL"
echo "        NUVYRA FINAL AUDIT" >> "$FINAL"
echo "==================================" >> "$FINAL"
echo "Date : $(date)" >> "$FINAL"
echo "" >> "$FINAL"



echo "===== RAPPORTS FUSIONNES =====" >> "$FINAL"
echo "" >> "$FINAL"



for FILE in "$REPORT_DIR"/*.txt
do

if [ "$FILE" != "$FINAL" ]
then

echo "----------------------------------" >> "$FINAL"
echo "SOURCE : $(basename "$FILE")" >> "$FINAL"
echo "----------------------------------" >> "$FINAL"

cat "$FILE" >> "$FINAL"

echo "" >> "$FINAL"

fi

done



echo "==================================" >> "$FINAL"
echo "FIN RAPPORT GLOBAL" >> "$FINAL"
echo "==================================" >> "$FINAL"



# Suppression des anciens rapports
find "$REPORT_DIR" \
-type f \
-name "*.txt" \
! -name "NUVYRA_AUDIT_FINAL.txt" \
-delete



# Nettoyage archives inutiles
rm -rf "$REPORT_DIR/archive"



echo ""
echo "Rapport unique créé :"
echo "$FINAL"

