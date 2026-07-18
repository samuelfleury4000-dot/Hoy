#!/usr/bin/env bash

LOCK=".nuvyra/nuvyra_daemon.lock"
LOG=".nuvyra/logs/daemon.log"

mkdir -p .nuvyra/logs

if [ -f "$LOCK" ]; then
    PID=$(cat "$LOCK")
    if kill -0 "$PID" 2>/dev/null; then
        echo "NUVYRA DAEMON DEJA ACTIF PID=$PID"
        exit 0
    fi
fi

echo $$ > "$LOCK"

trap 'rm -f "$LOCK"; exit' EXIT

while true
do
    echo "===== AUDIT $(date) =====" >> "$LOG"

    bash .nuvyra/nuvyra_master_audit.sh >> "$LOG" 2>&1

    echo "AUDIT TERMINE $(date)" >> "$LOG"

    sleep 300
done
