#!/usr/bin/env bash

REPORT=".nuvyra/reports/NUVYRA_AUDIT_FINAL.txt"

mkdir -p .nuvyra/reports


echo "========================================" > "$REPORT"
echo "          NUVYRA MASTER AUDIT" >> "$REPORT"
echo "========================================" >> "$REPORT"
echo "Date : $(date)" >> "$REPORT"
echo "" >> "$REPORT"



run(){

NAME=$1
FILE=$2


echo "" >> "$REPORT"
echo "========================================" >> "$REPORT"
echo " $NAME" >> "$REPORT"
echo "========================================" >> "$REPORT"


if [ -f ".nuvyra/modules/$FILE" ]
then

bash ".nuvyra/modules/$FILE" >> "$REPORT" 2>&1

else

echo "Module absent : $FILE" >> "$REPORT"

fi

}



run "CODE DOCTOR" code_doctor.sh
run "REACT QUALITY" react_quality.sh
run "CRYPTO SECURITY" crypto_security.sh
run "BLOCKCHAIN MONITOR" blockchain_monitor.sh
run "PERFORMANCE" performance.sh
run "PREDEPLOY GUARDIAN" predeploy_guardian.sh
run "AUTO FIX" auto_fix.sh



echo "" >> "$REPORT"
echo "========================================" >> "$REPORT"
echo "FIN AUDIT GLOBAL" >> "$REPORT"
echo "========================================" >> "$REPORT"



echo "Rapport généré : $REPORT"

