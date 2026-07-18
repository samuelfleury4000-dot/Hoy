#!/bin/bash

REPORT=".nuvyra/reports/NUVYRA_MASTER_SYSTEM_REPORT.txt"

{
echo "================================"
echo " NUVYRA MASTER SYSTEM REPORT"
echo "================================"

date

echo
echo "SYSTEM"

node -v
npm -v


echo
echo "BUILD"

npm run build >/dev/null 2>&1 \
&& echo "BUILD PASS" \
|| echo "BUILD FAIL"


echo
echo "SECURITY"

if grep -R "0x[a-fA-F0-9]\{64\}" src >/dev/null 2>&1
then
echo "PRIVATE KEY WARNING"
else
echo "PRIVATE KEY CLEAN"
fi


echo
echo "DEPENDENCIES"

npm audit --omit=dev


echo
echo "FILES"

find src -type f | wc -l


echo
echo "DISK"

df -h | head -2


echo
echo "STATUS"

echo "NUVYRA SYSTEM ONLINE"

} | tee "$REPORT"

