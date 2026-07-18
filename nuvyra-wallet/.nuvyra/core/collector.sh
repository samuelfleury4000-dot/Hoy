#!/bin/bash
BASE="$(cd "$(dirname "$0")/.." && pwd)"

cat > "$BASE/reports/system.json" <<JSON
{
"date":"$(date)",
"node":"$(node -v 2>/dev/null)",
"npm":"$(npm -v 2>/dev/null)",
"files":"$(find src -type f 2>/dev/null | wc -l)",
"size":"$(du -sh src 2>/dev/null | awk "{print $1}")",
"disk":"$(df -h / | tail -1 | awk "{print $5}")"
}
JSON
