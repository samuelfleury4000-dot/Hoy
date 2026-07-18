echo "NPM AUDIT"

npm audit --json 2>/dev/null | head -200 || true

echo ""
echo "PACKAGES"

npm list --depth=0
