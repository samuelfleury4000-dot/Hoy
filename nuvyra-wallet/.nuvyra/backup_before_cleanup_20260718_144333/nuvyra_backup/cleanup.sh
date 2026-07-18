#!/bin/bash
find .nuvyra/reports -type f -name "*.txt" -mtime +7 -delete
echo "Ancien rapports supprimés"
