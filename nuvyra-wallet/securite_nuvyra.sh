echo "===== SECURITE NUVYRA ====="

echo ""
echo "1) Verification .gitignore..."

touch .gitignore

grep -qxF ".env" .gitignore || echo ".env" >> .gitignore
grep -qxF "node_modules/" .gitignore || echo "node_modules/" >> .gitignore
grep -qxF "dist/" .gitignore || echo "dist/" >> .gitignore

echo "OK .gitignore configure"

echo ""
echo "2) Verification fichier .env..."

if [ -f .env ]; then
    echo "OK .env existe"
    echo ""
    echo "Contenu masque:"
    sed -E 's/(=).*/\1****/' .env
else
    echo "Aucun fichier .env trouve"
fi

echo ""
echo "3) Verification Git..."

if command -v git >/dev/null 2>&1; then

    git status --short

    echo ""
    echo "Fichiers sensibles suivis:"
    git ls-files | grep -E "\.env|secret|key|token" || echo "OK Aucun fichier sensible suivi"

else
    echo "Git non installe ou dossier non Git"
fi

echo ""
echo "4) Verification build..."

npm run build

echo ""
echo "===== SECURITE TERMINEE ====="
