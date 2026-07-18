REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"

echo "=================================" >> "$REPORT"
echo "        NUVYRA CODE DOCTOR" >> "$REPORT"
echo "=================================" >> "$REPORT"



echo "" >> "$REPORT"
echo "===== IMPORTS =====" >> "$REPORT"


grep -RIn \
"import .* from" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== POSSIBLE MISSING FILES =====" >> "$REPORT"


grep -RhoE \
'from ["'\''][^"'\'']+' \
src \
| sed 's/from //' \
| tr -d '"' \
| tr -d "'" \
| while read path

do

if [[ "$path" == .* ]]
then

FOUND=$(find src -path "*${path#./}*" | wc -l)

if [ "$FOUND" -eq 0 ]
then
echo "IMPORT POSSIBLEMENT CASSÉ : $path" >> "$REPORT"
fi

fi

done



echo "" >> "$REPORT"
echo "===== UNUSED COMPONENTS CHECK =====" >> "$REPORT"


for file in src/components/*.jsx

do

NAME=$(basename "$file" .jsx)

USE=$(grep -R "$NAME" src \
--exclude="$NAME.jsx" \
| wc -l)


if [ "$USE" -eq 0 ]
then
echo "COMPOSANT NON UTILISÉ : $NAME" >> "$REPORT"
fi

done



echo "" >> "$REPORT"
echo "===== DUPLICATES =====" >> "$REPORT"


find src -type f \
-name "*.jsx" \
-o -name "*.js" \
| while read f

do

HASH=$(md5sum "$f" | awk '{print $1}')

echo "$HASH $f"

done \
| sort \
| awk 'seen[$1]++ {print "DOUBLON POSSIBLE:",$0}' \
>> "$REPORT"



echo "" >> "$REPORT"
echo "===== FIN CODE DOCTOR =====" >> "$REPORT"

echo "$REPORT"

