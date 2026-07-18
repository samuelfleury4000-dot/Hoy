REPORT="${NUVYRA_REPORT:-.nuvyra/reports/NUVYRA_AUDIT.txt}"
BACKUP=".nuvyra/backups/autofix_$(date +%Y%m%d_%H%M%S).tar.gz"


echo "=================================" >> "$REPORT"
echo "       NUVYRA AUTO FIX ENGINE" >> "$REPORT"
echo "=================================" >> "$REPORT"


mkdir -p .nuvyra/backups



echo "" >> "$REPORT"
echo "===== BACKUP AVANT FIX =====" >> "$REPORT"


tar \
--exclude=node_modules \
--exclude=dist \
-czf "$BACKUP" . \
2>/dev/null


if [ -f "$BACKUP" ]
then
echo "Backup créé : $BACKUP" >> "$REPORT"
else
echo "Erreur backup - arrêt sécurité" >> "$REPORT"
exit 1
fi



echo "" >> "$REPORT"
echo "===== ANALYSE IMPORTS =====" >> "$REPORT"


grep -RIn \
"import .* from" \
src \
> .nuvyra/tmp/import_scan.txt || true



while read -r line

do

FILE=$(echo "$line" | cut -d: -f1)

echo "Vérification : $FILE" >> "$REPORT"


done < .nuvyra/tmp/import_scan.txt



echo "" >> "$REPORT"
echo "===== ERREURS CONNUES =====" >> "$REPORT"



# Détection export manquant

grep -RIn \
"not exported" \
.nuvyra/reports \
>> "$REPORT" || true



# Détection console inutile

COUNT=$(grep -RIn \
"console.log" \
src \
2>/dev/null | wc -l)


if [ "$COUNT" -gt 0 ]
then

echo "Console.log trouvés : $COUNT" >> "$REPORT"
echo "Action recommandée : nettoyer avant production" >> "$REPORT"

fi



# Détection TODO

TODO=$(grep -RIn \
"TODO\|FIXME" \
src \
2>/dev/null | wc -l)


echo "TODO détectés : $TODO" >> "$REPORT"



echo "" >> "$REPORT"
echo "===== RÉSULTAT =====" >> "$REPORT"

echo "Aucune modification automatique dangereuse effectuée." >> "$REPORT"

echo "Le backup permet un retour arrière." >> "$REPORT"


echo "$REPORT"

