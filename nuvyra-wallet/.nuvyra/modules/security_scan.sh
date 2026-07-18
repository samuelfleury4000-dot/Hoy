#!/usr/bin/env bash

echo "===== SECURITY SCAN ====="

grep -RInE \
"privateKey|seed|mnemonic|apikey|apiKey|secret|password" \
src \
--exclude-dir=node_modules \
--exclude-dir=dist \
2>/dev/null || echo "Aucun secret exposé détecté"

echo "SECURITY SCAN TERMINE"
