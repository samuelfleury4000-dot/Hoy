echo "SRC SIZE"

du -sh src 2>/dev/null || true

echo ""
echo "DIST SIZE"

du -sh dist 2>/dev/null || true


echo ""
echo "BIG FILES"

find src -type f -size +100k
