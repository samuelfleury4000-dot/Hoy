REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"

echo "=================================" >> "$REPORT"
echo "      NUVYRA REACT SCANNER" >> "$REPORT"
echo "=================================" >> "$REPORT"


echo "" >> "$REPORT"
echo "===== HOOKS =====" >> "$REPORT"


grep -RIn \
"useEffect\|useState\|useMemo\|useCallback" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== POSSIBLE UNUSED STATE =====" >> "$REPORT"


grep -RIn \
"const \[" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== CONSOLE LOG =====" >> "$REPORT"


grep -RIn \
"console.log" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== LARGE COMPONENTS =====" >> "$REPORT"


find src/components \
-name "*.jsx" \
-exec wc -l {} \; \
| sort -nr \
>> "$REPORT"



echo "" >> "$REPORT"
echo "===== JSX RISKS =====" >> "$REPORT"


grep -RIn \
"dangerouslySetInnerHTML\|eval(" \
src \
>> "$REPORT" || true


echo "FIN REACT SCAN" >> "$REPORT"

