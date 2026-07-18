#!/bin/bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "===== NUVYRA PRECOMMIT GUARD ====="

echo ""
echo "BUILD..."
cd "$ROOT"
npm run build >/dev/null 2>&1 || {
    echo "FAIL: build"
    exit 1
}

echo "SECURITY..."
bash "$ROOT/.nuvyra/checks/security.sh"

echo "ENGINE..."
bash "$ROOT/.nuvyra/engine.sh" >/dev/null

if grep -q "FAIL" "$ROOT/.nuvyra/reports/ENGINE_REPORT.txt"; then
    echo "FAIL: audit bloqué"
    exit 1
fi

echo ""
echo "PASS: NUVYRA READY TO COMMIT"
