#!/bin/bash

REPORT=".nuvyra/reports/NUVYRA_REALITY_CHECK.txt"
mkdir -p .nuvyra/reports

PASS=0
FAIL=0
INFO=0

check(){
NAME="$1"
CMD="$2"

if eval "$CMD" >/dev/null 2>&1; then
echo "PASS : $NAME"
PASS=$((PASS+1))
else
echo "FAIL : $NAME"
FAIL=$((FAIL+1))
fi
}

{
echo "================================"
echo " NUVYRA REALITY CHECK"
echo "================================"
echo
echo "DATE:"
date
echo


echo "===== COMMAND TEST ====="

for f in .nuvyra/*.sh .nuvyra/modules/*.sh; do
    if [ -f "$f" ]; then
        check "$f executable" "[ -x $f ]"
    fi
done


echo
echo "===== BUILD REAL TEST ====="

check "npm install state" "[ -d node_modules ]"
check "vite build" "npm run build"


echo
echo "===== SECURITY REAL TEST ====="

check "No private key" "! grep -RInE '0x[a-fA-F0-9]{64}|BEGIN PRIVATE KEY' src 2>/dev/null"

check "Env ignored" "grep -q '.env' .gitignore"


echo
echo "===== WALLET TEST ====="

check "Wallet module exists" "[ -f src/lib/wallet.js ]"
check "Transaction module exists" "[ -f src/lib/transaction.js ]"
check "Encryption exists" "grep -q 'encrypt' src/lib/wallet.js"


echo
echo "===== STORAGE TEST ====="

check "Local storage wallet" "grep -q 'localStorage' src/lib/wallet.js"


echo
echo "===== GIT TEST ====="

if git status --short >/tmp/nuvyra_git; then
COUNT=$(wc -l </tmp/nuvyra_git)

echo "Git changes detected: $COUNT"

if [ "$COUNT" -lt 20 ]; then
PASS=$((PASS+1))
echo "PASS : Repository clean enough"
else
INFO=$((INFO+1))
echo "INFO : Beaucoup de changements Git à nettoyer"
fi

fi


echo
echo "===== BACKGROUND SERVICES ====="

if pgrep -f "nuvyra_daemon" >/dev/null; then
echo "PASS : daemon actif"
PASS=$((PASS+1))
else
echo "INFO : daemon non détecté"
INFO=$((INFO+1))
fi


echo
echo "===== RESULTS ====="

TOTAL=$((PASS+FAIL))

echo
echo "TESTS:"
echo "$TOTAL"

echo "PASS:"
echo "$PASS"

echo "FAIL:"
echo "$FAIL"

echo "INFO:"
echo "$INFO"


if [ "$FAIL" -eq 0 ]; then
echo
echo "STATUS: 🟢 SYSTEME STABLE"
else
echo
echo "STATUS: 🔴 CORRECTIONS NECESSAIRES"
fi


echo
echo "================================"
echo " FIN REALITY CHECK"
echo "================================"

} | tee "$REPORT"


chmod 700 .nuvyra/NUVYRA_REALITY_CHECK.sh
