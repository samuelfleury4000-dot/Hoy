REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"

echo "=================================" >> "$REPORT"
echo "NUVYRA ERROR ANALYZER" >> "$REPORT"
date >> "$REPORT"
echo "=================================" >> "$REPORT"


echo "" >> "$REPORT"
echo "===== BUILD ERROR SCAN =====" >> "$REPORT"


npm run build > .nuvyra/tmp/build.log 2>&1 || true


grep -Ei \
"error|failed|not exported|cannot find|module|undefined|syntax|typeerror|referenceerror|rollup|vite" \
.nuvyra/tmp/build.log \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== BROKEN IMPORT CHECK =====" >> "$REPORT"


grep -RIn \
"import .* from" \
src \
>> .nuvyra/tmp/imports.txt || true


while read -r line
do

FILE=$(echo "$line" | cut -d: -f1)

IMPORT=$(echo "$line" | grep -oE 'from ["'\''][^"'\'']+' || true)

echo "$FILE -> $IMPORT"

done < .nuvyra/tmp/imports.txt \
>> "$REPORT"



echo "" >> "$REPORT"
echo "===== REACT COMMON ISSUES =====" >> "$REPORT"


grep -RIn \
"useEffect" \
src \
>> "$REPORT" || true


grep -RIn \
"console.log" \
src \
>> "$REPORT" || true


grep -RIn \
"dangerouslySetInnerHTML" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== TODO / FIXME =====" >> "$REPORT"


grep -RIn \
"TODO\|FIXME" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "FIN ANALYSE"
echo "$REPORT"

