#!/bin/bash

set -e

ROOT=".nuvyra"
DATE=$(date +%Y%m%d_%H%M%S)

echo "================================"
echo " NUVYRA SYSTEM UNIFIER"
echo "================================"

mkdir -p $ROOT/core
mkdir -p $ROOT/reports
mkdir -p $ROOT/logs
mkdir -p $ROOT/archive


echo
echo "[1] Nettoyage structure"

# déplacer anciens scripts non critiques
find $ROOT -maxdepth 1 -type f \
-name "*audit*" \
-o -name "*test*" \
-o -name "*check*" \
| while read FILE; do
    case "$FILE" in
      *NUVYRA_SYSTEM_UNIFIER.sh) ;;
      *)
      mv "$FILE" "$ROOT/archive/" 2>/dev/null || true
      ;;
    esac
done


echo
echo "[2] Création moteur central"


cat > $ROOT/core/engine.sh <<'ENGINE'
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

ENGINE


chmod 700 $ROOT/core/engine.sh


echo
echo "[3] Création commande unique"


cat > $ROOT/NUVYRA_ONE_COMMAND.sh <<'MAIN'
#!/bin/bash

echo "================================"
echo " NUVYRA CONTROL CENTER"
echo "================================"

bash .nuvyra/core/engine.sh

echo
echo "Rapport:"
echo ".nuvyra/reports/NUVYRA_MASTER_SYSTEM_REPORT.txt"

MAIN


chmod 700 $ROOT/NUVYRA_ONE_COMMAND.sh


echo
echo "[4] Permissions sécurité"

find $ROOT -type f -name "*.sh" -exec chmod 700 {} \;


echo
echo "[5] Nettoyage logs"

find $ROOT/logs -type f -size +2M -delete 2>/dev/null || true


echo
echo "[6] Test final"

bash $ROOT/NUVYRA_ONE_COMMAND.sh


echo
echo "================================"
echo " NUVYRA UNIFIED SYSTEM READY"
echo "================================"

