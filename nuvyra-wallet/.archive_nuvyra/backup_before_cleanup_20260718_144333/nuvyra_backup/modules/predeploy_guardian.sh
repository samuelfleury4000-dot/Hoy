REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"
BACKUP=".nuvyra/backups/predeploy_$(date +%Y%m%d_%H%M%S).tar.gz"

FAIL=0


echo "=================================" >> "$REPORT"
echo "     NUVYRA PRE DEPLOY GUARDIAN" >> "$REPORT"
echo "=================================" >> "$REPORT"


echo "" >> "$REPORT"
echo "===== BACKUP =====" >> "$REPORT"


mkdir -p .nuvyra/backups

tar \
--exclude=node_modules \
--exclude=dist \
-czf "$BACKUP" . \
2>/dev/null


if [ -f "$BACKUP" ]
then
echo "BACKUP OK : $BACKUP" >> "$REPORT"
else
echo "BACKUP FAILED" >> "$REPORT"
FAIL=1
fi



echo "" >> "$REPORT"
echo "===== BUILD =====" >> "$REPORT"


npm run build >> "$REPORT" 2>&1


if [ $? -eq 0 ]
then
echo "BUILD OK" >> "$REPORT"
else
echo "BUILD FAILED" >> "$REPORT"
FAIL=1
fi



echo "" >> "$REPORT"
echo "===== SECRET CHECK =====" >> "$REPORT"


SECRET=$(grep -RInE \
"PRIVATE_KEY|API_KEY|SECRET_KEY" \
src \
.env \
2>/dev/null | wc -l)


if [ "$SECRET" -eq 0 ]
then
echo "NO SECRET FOUND" >> "$REPORT"
else
echo "WARNING SECRET PATTERN FOUND" >> "$REPORT"
FAIL=1
fi



echo "" >> "$REPORT"
echo "===== ENV CHECK =====" >> "$REPORT"


if [ -f ".env" ]
then
echo ".env PRESENT : verify before deploy" >> "$REPORT"
else
echo "NO .env FILE" >> "$REPORT"
fi



echo "" >> "$REPORT"
echo "===== BUNDLE SIZE =====" >> "$REPORT"


if [ -d dist ]
then

SIZE=$(du -sh dist | awk '{print $1}')

echo "DIST SIZE : $SIZE" >> "$REPORT"

else

echo "DIST NOT FOUND" >> "$REPORT"
FAIL=1

fi



echo "" >> "$REPORT"


if [ "$FAIL" -eq 0 ]
then

echo "STATUS : READY FOR DEPLOY" >> "$REPORT"

else

echo "STATUS : BLOCKED - REVIEW REQUIRED" >> "$REPORT"

fi



echo "$REPORT"

