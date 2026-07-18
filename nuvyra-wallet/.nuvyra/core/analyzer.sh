#!/bin/bash
BASE="$(dirname $(dirname "$0"))"

grep -R -E "PRIVATE_KEY|BEGIN PRIVATE|0x[a-fA-F0-9]{64}" src >/dev/null 2>&1 \
&& SECURITY="FAIL" || SECURITY="PASS"

npm run build >/dev/null 2>&1 \
&& BUILD="PASS" || BUILD="FAIL"

cat > "$BASE/reports/checks.json" <<JSON
{
"security":"$SECURITY",
"build":"$BUILD"
}
JSON
