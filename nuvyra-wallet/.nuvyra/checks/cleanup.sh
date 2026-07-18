#!/bin/bash

REPORTS=".nuvyra/reports"

mkdir -p "$REPORTS"

cp "$REPORTS/ENGINE_REPORT.txt" "$REPORTS/latest.txt" 2>/dev/null || true

find "$REPORTS" -maxdepth 1 -type f -name "*.txt" ! -name "latest.txt" \
| xargs -r ls -1t \
| tail -n +11 \
| xargs -r rm -f

find . -maxdepth 1 -type f -name "*.txt" \
! -name "README.txt" \
! -name "LICENSE.txt" \
-delete

echo "PASS: Reports rotated"
