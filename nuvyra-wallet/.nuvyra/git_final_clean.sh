#!/bin/bash

echo "NUVYRA GIT FINAL CLEAN"

# Ajouter protections git
cat >> .gitignore <<'GIT'

# NUVYRA SECURITY
.env
.env.*
node_modules/
dist/
.nuvyra/logs/
.nuvyra/reports/
.nuvyra/archive*/
*.log

GIT

# retirer fichiers temporaires du suivi
git rm -r --cached .nuvyra/logs 2>/dev/null || true
git rm -r --cached .nuvyra/reports 2>/dev/null || true
git rm -r --cached .nuvyra/archive* 2>/dev/null || true

# retirer exports inutiles
git rm --cached export_nuvyra_core.sh 2>/dev/null || true
git rm --cached export_source_clean.sh 2>/dev/null || true

# garder seulement scripts utiles
chmod 700 .nuvyra/*.sh 2>/dev/null

git add .
git commit -m "NUVYRA security cleanup and hardening"

echo "GIT CLEAN COMPLETE"
