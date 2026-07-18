#!/bin/bash

REPORT=".nuvyra/reports/ENGINE_REPORT.txt"

echo "===== SECURITY =====" >> "$REPORT"

REAL_SECRET=$(grep -RInE \
"(0x[a-fA-F0-9]{64}|-----BEGIN PRIVATE KEY-----|mnemonic\s*=\s*['\"][^'\"]{20,}|seed\s*=\s*['\"][^'\"]{20,})" \
src 2>/dev/null)

if [ -z "$REAL_SECRET" ]; then
    echo "PASS: Aucun secret réel exposé" >> "$REPORT"
else
    echo "WARNING: Secret potentiel détecté" >> "$REPORT"
    echo "$REAL_SECRET" >> "$REPORT"
fi

PRIVATE_STORAGE=$(grep -RInE \
"localStorage.*(private|seed|mnemonic)|sessionStorage.*(private|seed|mnemonic)" \
src 2>/dev/null)

if [ -z "$PRIVATE_STORAGE" ]; then
    echo "PASS: Pas de stockage direct seed/private key" >> "$REPORT"
else
    echo "WARNING: Stockage sensible détecté" >> "$REPORT"
    echo "$PRIVATE_STORAGE" >> "$REPORT"
fi
