echo "===== AUTO CLEANUP ====="


REPORT_DIR=".nuvyra/reports"
HISTORY_DIR=".nuvyra/history"
TMP_DIR=".nuvyra/tmp"


mkdir -p "$HISTORY_DIR"



echo "Archivage des anciens rapports..."


find "$REPORT_DIR" \
-type f \
-mmin +15 \
-name "*.txt" \
-exec mv {} "$HISTORY_DIR"/ \;



echo "Suppression anciens historiques..."


COUNT=$(find "$HISTORY_DIR" -type f | wc -l)


if [ "$COUNT" -gt 50 ]
then

find "$HISTORY_DIR" \
-type f \
printf '%T@ %p\n' | \
sort -n | \
head -n -40 | \
cut -d' ' -f2- | \
xargs -r rm

fi



echo "Nettoyage fichiers temporaires..."


find "$TMP_DIR" \
-type f \
-mmin +30 \
-delete



echo "Compression archives..."


find "$HISTORY_DIR" \
-type f \
-name "*.txt" \
-mmin +60 \
| while read file

do

gzip -f "$file" 2>/dev/null || true

done



echo "Nettoyage terminé"

