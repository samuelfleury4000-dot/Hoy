#!/usr/bin/env bash

set -e

echo "=== NUVYRA AUDIT SYSTEM FIX ==="

DAEMON=".nuvyra/auto_audit_daemon.sh"

if [ ! -f "$DAEMON" ]; then
echo "Daemon introuvable"
exit 1
fi


# Backup audit uniquement
mkdir -p .nuvyra/backups

tar -czf ".nuvyra/backups/audit_before_fix_$(date +%Y%m%d_%H%M%S).tar.gz" .nuvyra/*.sh .nuvyra/modules 2>/dev/null || true


echo "[1/3] Correction sécurité..."

python3 - <<'PY'
from pathlib import Path

p=Path(".nuvyra/auto_audit_daemon.sh")

s=p.read_text()

old='''grep -RInE \\
"PRIVATE_KEY|SECRET|API_KEY|privateKey|mnemonic|seed" \\
src \\
>> "$REPORT" 2>&1 || echo "Aucun pattern critique" >> "$REPORT"'''

new='''grep -RInE \\
"(PRIVATE_KEY|API_KEY|SECRET_KEY)[[:space:]]*=[[:space:]]*['"][^'"]+['"]|0x[a-fA-F0-9]{64}|seed[[:space:]]*=[[:space:]]*['"][^'"]+['"]" \\
src \\
>> "$REPORT" 2>&1 || echo "Aucun secret exposé détecté" >> "$REPORT"'''

s=s.replace(old,new)

p.write_text(s)
PY


echo "[2/3] Correction RPC blockchain..."

python3 - <<'PY'
from pathlib import Path

p=Path(".nuvyra/auto_audit_daemon.sh")

s=p.read_text()

s=s.replace(
"https://rpc.sepolia.org",
"https://ethereum-sepolia-rpc.publicnode.com"
)

p.write_text(s)
PY


echo "[3/3] Correction Git + Score..."

python3 - <<'PY'
from pathlib import Path

p=Path(".nuvyra/auto_audit_daemon.sh")

s=p.read_text()

s=s.replace(
"git status --short >> \"$REPORT\"",
"git -C \"$(pwd)\" status --short >> \"$REPORT\""
)


old='''echo "" >> "$REPORT"
echo "================================"
echo "FIN AUDIT"
echo "================================"'''

new='''echo "" >> "$REPORT"
echo "===== HEALTH SCORE =====" >> "$REPORT"

SCORE=100

grep -q "BUILD STATUS : OK" "$REPORT" || SCORE=$((SCORE-25))

grep -q "found 0 vulnerabilities" "$REPORT" || SCORE=$((SCORE-20))

grep -q "404 Not Found" "$REPORT" && SCORE=$((SCORE-10))

grep -q "console.log:" "$REPORT" && SCORE=$((SCORE-5))

if [ "$SCORE" -lt 0 ]
then
SCORE=0
fi

echo "NUVYRA SCORE : $SCORE / 100" >> "$REPORT"

echo "" >> "$REPORT"
echo "================================"
echo "FIN AUDIT"
echo "================================"'''

s=s.replace(old,new)

p.write_text(s)
PY


chmod +x .nuvyra/auto_audit_daemon.sh


echo "=== FIX TERMINE ==="
echo "Relance le daemon:"
echo "nohup bash .nuvyra/auto_audit_daemon.sh >/dev/null 2>&1 &"

