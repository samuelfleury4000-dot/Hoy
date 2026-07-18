#!/usr/bin/env bash

set -o pipefail

ROOT="$(pwd)"

DATE=$(date +%Y%m%d_%H%M%S)

REPORT="$ROOT/.nuvyra/reports/NUVYRA_AUDIT_$DATE.txt"

mkdir -p .nuvyra/reports
mkdir -p .nuvyra/tmp


echo "=====================================" > "$REPORT"
echo "          NUVYRA FULL AUDIT" >> "$REPORT"
echo "=====================================" >> "$REPORT"

echo "Date : $(date)" >> "$REPORT"
echo "" >> "$REPORT"



run_module(){

NAME=$1
FILE=$2


echo "" >> "$REPORT"
echo "=====================================" >> "$REPORT"
echo " $NAME" >> "$REPORT"
echo "=====================================" >> "$REPORT"


if [ -f ".nuvyra/modules/$FILE" ]
then

bash ".nuvyra/modules/$FILE" >> "$REPORT" 2>&1


if [ $? -eq 0 ]
then
echo "" >> "$REPORT"
echo "STATUS : OK" >> "$REPORT"
else
echo "" >> "$REPORT"
echo "STATUS : WARNING" >> "$REPORT"
fi


else

echo "MODULE MANQUANT : $FILE" >> "$REPORT"

fi

}



run_module "SYSTEM" system.sh
run_module "DEPENDENCIES" dependencies.sh
run_module "BUILD" build.sh
run_module "SECURITY" security.sh
run_module "SIZE" size.sh
run_module "GIT" git.sh
run_module "ERROR ANALYSIS" error_analyzer.sh
run_module "HEALTH SCORE" health_score.sh
run_module "CLEANUP" cleanup.sh
run_module "CODE DOCTOR" code_doctor.sh
run_module "PREDEPLOY GUARDIAN" predeploy_guardian.sh
run_module "AUTO FIX ENGINE" auto_fix.sh
run_module "BLOCKCHAIN MONITOR" blockchain_monitor.sh
run_module "REACT QUALITY" react_quality.sh
run_module "CRYPTO SECURITY" crypto_security.sh
run_module "PERFORMANCE" performance.sh



echo "" >> "$REPORT"
echo "=====================================" >> "$REPORT"
echo " FIN AUDIT NUVYRA" >> "$REPORT"
echo "=====================================" >> "$REPORT"



echo ""
echo "AUDIT COMPLET TERMINE"
echo "Rapport unique :"
echo "$REPORT"

bash .nuvyra/final_report_cleaner.sh
