#!/usr/bin/env bash

DIR=".nuvyra/reports"

mkdir -p "$DIR"

for TYPE in report audit; do
  FILE=$(ls -t "$DIR"/${TYPE}_*.txt 2>/dev/null | tail -n +2)
  [ -n "$FILE" ] && rm -f $FILE
done

echo "$(date) REPORT CLEANUP OK" >> .nuvyra/logs/cleanup.log
