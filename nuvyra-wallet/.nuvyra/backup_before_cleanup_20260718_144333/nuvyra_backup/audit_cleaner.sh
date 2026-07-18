#!/usr/bin/env bash

find .nuvyra/logs -type f -name "*.log" -mtime +7 -delete
find .nuvyra/reports -type f -mtime +7 -delete

echo "AUDIT CLEANUP OK"
