#!/usr/bin/env bash

BASE=".nuvyra"

mkdir -p "$BASE/logs" "$BASE/reports" "$BASE/backups"

echo "NUVYRA CLEANUP"

find "$BASE/reports" -type f -delete 2>/dev/null
find "$BASE/logs" -type f -name "*.log" -delete 2>/dev/null
find "$BASE/backups" -type f -name "*.tar.gz" -delete 2>/dev/null

echo "Rapports anciens supprimés"
