#!/usr/bin/env bash

REPORT=".nuvyra/reports/NUVYRA_AUDIT_FINAL.txt"

mkdir -p .nuvyra/reports


echo "================================" > "$REPORT"
echo "        NUVYRA AUDIT" >> "$REPORT"
echo "================================" >> "$REPORT"
echo "Date: $(date)" >> "$REPORT"
echo "" >> "$REPORT"


SCORE=100



echo "BUILD" >> "$REPORT"
echo "-----" >> "$REPORT"

if npm run build >/dev/null 2>&1
then
echo "✅ Build OK" >> "$REPORT"
else
echo "❌ Build FAILED" >> "$REPORT"
SCORE=$((SCORE-25))
fi



echo "" >> "$REPORT"
echo "DEPENDENCIES" >> "$REPORT"
echo "------------" >> "$REPORT"

npm audit --omit=dev 2>/dev/null \
| grep "vulnerabilities" \
>> "$REPORT" || echo "✅ Audit npm OK" >> "$REPORT"



echo "" >> "$REPORT"
echo "SECURITY" >> "$REPORT"
echo "---------" >> "$REPORT"

grep -RInE \
"mnemonic|privateKey|seed|localStorage|encrypt" \
src \
2>/dev/null \
| head -10 >> "$REPORT"




echo "" >> "$REPORT"
echo "REACT QUALITY" >> "$REPORT"
echo "-------------" >> "$REPORT"

grep -RIn \
"useEffect" \
src \
| wc -l \
| awk '{print "useEffect trouvés : "$1}' >> "$REPORT"


grep -RIn \
"console.log" \
src \
2>/dev/null \
| wc -l \
| awk '{print "Console.log : "$1}' >> "$REPORT"



echo "" >> "$REPORT"
echo "CRYPTO WALLET" >> "$REPORT"
echo "-------------" >> "$REPORT"


grep -RIn \
"ethers.Wallet\|encrypt\|fromPhrase\|sendTransaction" \
src \
2>/dev/null \
| head -15 >> "$REPORT"



echo "" >> "$REPORT"
echo "BLOCKCHAIN" >> "$REPORT"
echo "----------" >> "$REPORT"


curl -s \
-X POST \
-H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
https://rpc.sepolia.org \
| grep -q result


if [ $? -eq 0 ]
then
echo "✅ Sepolia RPC OK" >> "$REPORT"
else
echo "⚠️ Sepolia RPC indisponible" >> "$REPORT"
SCORE=$((SCORE-5))
fi



echo "" >> "$REPORT"
echo "GIT" >> "$REPORT"
echo "---" >> "$REPORT"

git status --short >> "$REPORT"




echo "" >> "$REPORT"
echo "PERFORMANCE" >> "$REPORT"
echo "-----------" >> "$REPORT"


du -sh src dist 2>/dev/null >> "$REPORT"



echo "" >> "$REPORT"
echo "FILES" >> "$REPORT"
echo "-----" >> "$REPORT"

find src -type f | wc -l \
| awk '{print "Fichiers source : "$1}' >> "$REPORT"



echo "" >> "$REPORT"

echo "================================" >> "$REPORT"
echo "SCORE FINAL : $SCORE / 100" >> "$REPORT"
echo "================================" >> "$REPORT"

