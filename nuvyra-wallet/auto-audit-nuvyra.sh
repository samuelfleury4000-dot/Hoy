#!/bin/bash

OUTPUT="audit-result.txt"

echo "====================================" > $OUTPUT
echo " NUVYRA AUTO AUDIT REPORT" >> $OUTPUT
echo " $(date)" >> $OUTPUT
echo "====================================" >> $OUTPUT


echo "" >> $OUTPUT
echo "===== NODE VERSION =====" >> $OUTPUT
node -v >> $OUTPUT 2>&1


echo "" >> $OUTPUT
echo "===== NPM CHECK =====" >> $OUTPUT
npm --version >> $OUTPUT 2>&1


echo "" >> $OUTPUT
echo "===== DEPENDENCIES =====" >> $OUTPUT
npm list --depth=0 >> $OUTPUT 2>&1


echo "" >> $OUTPUT
echo "===== SECURITY AUDIT =====" >> $OUTPUT
npm audit >> $OUTPUT 2>&1


echo "" >> $OUTPUT
echo "===== BUILD TEST =====" >> $OUTPUT
npm run build >> $OUTPUT 2>&1


echo "" >> $OUTPUT
echo "===== POSSIBLE CODE PROBLEMS =====" >> $OUTPUT

echo "--- console.log ---" >> $OUTPUT
grep -R "console.log" src >> $OUTPUT 2>&1


echo "--- TODO ---" >> $OUTPUT
grep -R "TODO" src >> $OUTPUT 2>&1


echo "--- dangerous keys ---" >> $OUTPUT
grep -R "privateKey\|seed\|mnemonic" src >> $OUTPUT 2>&1


echo "--- duplicate code suspects ---" >> $OUTPUT
grep -R "Copier l'adresse" src >> $OUTPUT 2>&1


echo "" >> $OUTPUT
echo "===== FILE LIST =====" >> $OUTPUT
find src -type f >> $OUTPUT


echo "" >> $OUTPUT
echo "====================================" >> $OUTPUT
echo " AUDIT FINI" >> $OUTPUT
echo "====================================" >> $OUTPUT


echo "Rapport créé : $OUTPUT"
