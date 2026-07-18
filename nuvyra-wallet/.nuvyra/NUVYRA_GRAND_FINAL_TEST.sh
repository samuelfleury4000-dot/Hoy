#!/bin/bash

REPORT=".nuvyra/reports/NUVYRA_FINAL_MASTER_REPORT.txt"
mkdir -p .nuvyra/reports

echo "================================" > $REPORT
echo "     NUVYRA GRAND FINAL TEST" >> $REPORT
echo "================================" >> $REPORT
date >> $REPORT

echo "" >> $REPORT
echo "===== CLEANUP CHECK =====" >> $REPORT

find .nuvyra/reports -type f \
! -name "NUVYRA_FINAL_MASTER_REPORT.txt" \
-delete

echo "OLD REPORTS CLEANED" >> $REPORT


echo "" >> $REPORT
echo "===== SYSTEM =====" >> $REPORT

node -v >> $REPORT
npm -v >> $REPORT


echo "" >> $REPORT
echo "===== STRUCTURE =====" >> $REPORT

find src -type f | sort >> $REPORT


echo "" >> $REPORT
echo "===== BUILD =====" >> $REPORT

npm run build >> $REPORT 2>&1

if [ $? -eq 0 ]; then
echo "BUILD STATUS: PASS" >> $REPORT
else
echo "BUILD STATUS: FAIL" >> $REPORT
fi


echo "" >> $REPORT
echo "===== DEPENDENCIES =====" >> $REPORT

npm audit --omit=dev >> $REPORT 2>&1


echo "" >> $REPORT
echo "===== SECURITY =====" >> $REPORT

if grep -RInE "0x[a-fA-F0-9]{64}|PRIVATE_KEY|SECRET_KEY|BEGIN PRIVATE" src >/dev/null
then
echo "WARNING SECRET PATTERN FOUND" >> $REPORT
else
echo "PRIVATE KEY CLEAN" >> $REPORT
fi


echo "" >> $REPORT
echo "===== WALLET =====" >> $REPORT

grep -RInE "encrypt|fromEncryptedJson|createRandom|mnemonic" src/lib src/components >> $REPORT


echo "" >> $REPORT
echo "===== PERFORMANCE =====" >> $REPORT

du -sh src >> $REPORT
du -sh dist >> $REPORT


echo "" >> $REPORT
echo "===== DISK =====" >> $REPORT

df -h >> $REPORT


echo "" >> $REPORT
echo "===== SERVICES =====" >> $REPORT

if pgrep -f nuvyra_daemon >/dev/null
then
echo "24/7 DAEMON ACTIVE" >> $REPORT
else
echo "DAEMON NOT ACTIVE" >> $REPORT
fi


echo "" >> $REPORT
echo "===== FINAL STATUS =====" >> $REPORT
echo "NUVYRA AUDIT ENGINE SYNCHRONIZED" >> $REPORT
echo "REPORT: $REPORT" >> $REPORT

echo "================================"
echo " FINAL TEST COMPLETE"
echo "================================"
cat $REPORT

