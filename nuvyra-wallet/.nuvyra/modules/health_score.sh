REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"

SCORE=100


echo "=================================" >> "$REPORT"
echo "        NUVYRA HEALTH SCORE" >> "$REPORT"
echo "=================================" >> "$REPORT"
echo "" >> "$REPORT"



echo "Analyse en cours..." >> "$REPORT"


# BUILD
if npm run build >/dev/null 2>&1
then
echo "BUILD .............. +20 OK" >> "$REPORT"
else
SCORE=$((SCORE-20))
echo "BUILD .............. -20 FAIL" >> "$REPORT"
fi



# SECURITY
VULN=$(npm audit --json 2>/dev/null | grep -o '"vulnerabilities"' | wc -l)

if [ "$VULN" -eq 0 ]
then
echo "SECURITY ........... +20 OK" >> "$REPORT"
else
SCORE=$((SCORE-20))
echo "SECURITY ........... -20 WARNING" >> "$REPORT"
fi



# SECRETS
SECRET=$(grep -RInE \
"PRIVATE_KEY|API_KEY|SECRET|MNEMONIC" \
src \
2>/dev/null | wc -l)


if [ "$SECRET" -eq 0 ]
then
echo "SECRETS ............ +15 OK" >> "$REPORT"
else
SCORE=$((SCORE-15))
echo "SECRETS ............ -15 REVIEW" >> "$REPORT"
fi



# TODO
TODO=$(grep -RIn \
"TODO\|FIXME" \
src \
2>/dev/null | wc -l)


if [ "$TODO" -lt 5 ]
then
echo "CODE QUALITY ....... +15 OK" >> "$REPORT"
else
SCORE=$((SCORE-10))
echo "CODE QUALITY ....... -10 TODO" >> "$REPORT"
fi



# SIZE
SIZE=$(du -s src 2>/dev/null | awk '{print $1}')

if [ "$SIZE" -lt 5000 ]
then
echo "PROJECT SIZE ....... +10 OK" >> "$REPORT"
else
SCORE=$((SCORE-10))
echo "PROJECT SIZE ....... -10 LARGE" >> "$REPORT"
fi



# GIT
if git diff --quiet
then
echo "GIT STATUS ......... +10 CLEAN" >> "$REPORT"
else
SCORE=$((SCORE-5))
echo "GIT STATUS ......... -5 CHANGES" >> "$REPORT"
fi



if [ "$SCORE" -lt 0 ]
then
SCORE=0
fi


echo "" >> "$REPORT"
echo "============================" >> "$REPORT"
echo "FINAL SCORE : $SCORE / 100" >> "$REPORT"
echo "============================" >> "$REPORT"


