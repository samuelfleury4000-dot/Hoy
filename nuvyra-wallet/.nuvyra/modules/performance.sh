REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"


echo "=================================" >> "$REPORT"
echo "      NUVYRA PERFORMANCE" >> "$REPORT"
echo "=================================" >> "$REPORT"



echo "Bundle:" >> "$REPORT"

du -sh dist >> "$REPORT" 2>/dev/null || true


echo "" >> "$REPORT"

echo "JS chunks:" >> "$REPORT"

find dist \
-name "*.js" \
-exec du -h {} \; \
>> "$REPORT"



echo "" >> "$REPORT"

echo "Dependencies:" >> "$REPORT"

npm list --depth=0 >> "$REPORT"



echo "FIN PERFORMANCE" >> "$REPORT"

