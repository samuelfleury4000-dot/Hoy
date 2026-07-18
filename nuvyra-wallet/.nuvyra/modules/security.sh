echo "SEARCH SECRET PATTERNS"

grep -RInE \
"(PRIVATE_KEY|SECRET|API_KEY|MNEMONIC|PASSWORD|seed|privateKey)" \
src \
--exclude-dir=node_modules \
|| true


echo ""
echo "ENV FILES"

find . \
-name ".env" \
-o -name "*.env" \
2>/dev/null
