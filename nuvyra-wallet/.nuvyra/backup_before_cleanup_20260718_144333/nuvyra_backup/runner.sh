#!/usr/bin/env bash

DATE=$(date +%Y%m%d_%H%M%S)

export NUVYRA_REPORT=".nuvyra/reports/NUVYRA_MASTER_$DATE.txt"

mkdir -p .nuvyra/reports


echo "==================================" > "$NUVYRA_REPORT"
echo "        NUVYRA MASTER AUDIT" >> "$NUVYRA_REPORT"
echo "==================================" >> "$NUVYRA_REPORT"
echo "Date: $(date)" >> "$NUVYRA_REPORT"
echo "" >> "$NUVYRA_REPORT"



run(){

NAME=$1
FILE=$2


echo "" >> "$NUVYRA_REPORT"
echo "========== $NAME ==========" >> "$NUVYRA_REPORT"



if [ -f ".nuvyra/modules/$FILE" ]
then

REPORT="$NUVYRA_REPORT" \
bash ".nuvyra/modules/$FILE" >> "$NUVYRA_REPORT" 2>&1

else

echo "MODULE MANQUANT" >> "$NUVYRA_REPORT"

fi

}



for module in .nuvyra/modules/*.sh
do

NAME=$(basename "$module")

run "$NAME" "$NAME"

done



echo "" >> "$NUVYRA_REPORT"
echo "==================================" >> "$NUVYRA_REPORT"
echo "AUDIT TERMINE" >> "$NUVYRA_REPORT"
echo "==================================" >> "$NUVYRA_REPORT"



echo "Rapport unique:"
echo "$NUVYRA_REPORT"

