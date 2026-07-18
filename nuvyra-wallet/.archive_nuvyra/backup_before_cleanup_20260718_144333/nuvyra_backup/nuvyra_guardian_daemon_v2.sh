#!/bin/bash

BASE="$(cd "$(dirname "$0")/.." && pwd)"
AUDIT="$BASE/.nuvyra/NUVYRA_ONE_CLICK_AUDIT.sh"
LOG="$BASE/.nuvyra/logs/guardian_v2.log"
STATUS="$BASE/.nuvyra/logs/guardian_v2.status"

mkdir -p "$BASE/.nuvyra/logs"

echo "NUVYRA GUARDIAN V2 STARTED $(date)" >> "$LOG"

while true
do
    echo "================================" > "$STATUS"
    echo "NUVYRA GUARDIAN V2" >> "$STATUS"
    echo "RUNNING: $(date)" >> "$STATUS"

    if [ -f "$AUDIT" ]; then

        echo "AUDIT START" >> "$LOG"

        bash "$AUDIT" >> "$LOG" 2>&1

        if grep -q "PRODUCTION READY" "$LOG"; then
            echo "SYSTEM: CLEAN" >> "$STATUS"
        else
            echo "SYSTEM: REVIEW REQUIRED" >> "$STATUS"
        fi

        echo "LAST AUDIT: $(date)" >> "$STATUS"

    else

        echo "ERROR: AUDIT SCRIPT MISSING" >> "$STATUS"
        echo "Missing audit script $(date)" >> "$LOG"

    fi

    echo "NEXT CHECK: 30 minutes" >> "$STATUS"

    sleep 1800
done
