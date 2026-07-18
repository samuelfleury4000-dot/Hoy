REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"


echo "=================================" >> "$REPORT"
echo "     NUVYRA CRYPTO SECURITY" >> "$REPORT"
echo "=================================" >> "$REPORT"



echo "" >> "$REPORT"
echo "===== WALLET FILE CHECK =====" >> "$REPORT"



grep -RIn \
"mnemonic\|privateKey\|seed\|encrypt\|localStorage" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== STORAGE CHECK =====" >> "$REPORT"


grep -RIn \
"localStorage" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== TRANSACTION CHECK =====" >> "$REPORT"


grep -RIn \
"sendTransaction\|parseEther\|gas" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "===== ADDRESS CHECK =====" >> "$REPORT"


grep -RIn \
"0x" \
src \
>> "$REPORT" || true



echo "" >> "$REPORT"
echo "FIN SECURITY AUDIT" >> "$REPORT"

