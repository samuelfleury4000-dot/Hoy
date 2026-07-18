#!/bin/bash

REPORT=".nuvyra/reports/ENGINE_REPORT.txt"

echo "===== SECURITY =====" >> "$REPORT"

SECRET=$(grep -RInE \
"(0x[a-fA-F0-9]{64}|-----BEGIN PRIVATE KEY-----|AKIA[0-9A-Z]{16}|sk_live_[a-zA-Z0-9]+)" \
src 2>/dev/null)

if [ -z "$SECRET" ]; then
    echo "PASS: Aucun secret réel exposé" >> "$REPORT"
else
    echo "WARNING: Secret réel potentiel détecté" >> "$REPORT"
    echo "$SECRET" >> "$REPORT"
fi

STORAGE=$(grep -RInE \
"localStorage.*(private|seed)|sessionStorage.*(private|seed)" \
src 2>/dev/null)

if [ -z "$STORAGE" ]; then
    echo "PASS: Pas de stockage direct sensible" >> "$REPORT"
else
    echo "WARNING: Stockage sensible détecté" >> "$REPORT"
    echo "$STORAGE" >> "$REPORT"
fi
