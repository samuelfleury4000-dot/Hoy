#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

find "$ROOT/reports" -type f -mmin +15 -delete 2>/dev/null
find "$ROOT/logs" -type f -mmin +15 -delete 2>/dev/null
find "$ROOT/backups" -type f -mmin +15 -delete 2>/dev/null

find "$ROOT" -maxdepth 1 \
\( \
-name "*REPORT*.txt" -o \
-name "*report*.txt" -o \
-name "*audit*.txt" -o \
-name "*AUDIT*.txt" -o \
-name "*security*.txt" -o \
-name "*build*.txt" -o \
-name "*test*.txt" -o \
-name "stable-build.txt" -o \
-name "error-report*.txt" -o \
-name "build-errors*.txt" -o \
-name "nuvyra-*.txt" \
\) \
-mmin +15 \
-delete 2>/dev/null

echo "[$(date)] Nettoyage terminé."
