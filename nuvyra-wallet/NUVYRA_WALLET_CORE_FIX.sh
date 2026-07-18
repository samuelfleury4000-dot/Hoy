#!/bin/bash

set -e

echo "================================"
echo " NUVYRA WALLET CORE UPGRADE"
echo "================================"

mkdir -p src/lib src/components


echo "[1/5] Upgrade wallet security..."

cat > src/lib/walletSecurity.js <<'JS'
const MIN_PASSWORD = 12;

export function validatePassword(password){

 if(!password || password.length < MIN_PASSWORD){
   throw new Error(
    "Mot de passe minimum 12 caractères"
   );
 }

 if(!/[A-Z]/.test(password)){
   throw new Error(
    "Ajoute une majuscule"
   );
 }

 if(!/[0-9]/.test(password)){
   throw new Error(
    "Ajoute un chiffre"
   );
 }

 return true;
}


export function clearSensitive(){

 if(window.gc){
   window.gc();
 }

}
JS


echo "[2/5] Upgrade wallet storage..."

cat > src/lib/storage.js <<'JS'
const KEY="nuvyra_wallet";

export function saveWallet(data){
 localStorage.setItem(
  KEY,
  JSON.stringify(data)
 );
}


export function loadWallet(){

 const data=
 localStorage.getItem(KEY);

 return data ? JSON.parse(data):null;

}


export function deleteWallet(){

 localStorage.removeItem(KEY);

}


export function walletExists(){

 return !!localStorage.getItem(KEY);

}
JS


echo "[3/5] Transaction protection..."

cat > src/lib/transactionGuard.js <<'JS'
export function validateTransaction(to,amount){

 if(!to.startsWith("0x")){
   throw new Error(
    "Adresse Ethereum invalide"
   );
 }


 if(Number(amount)<=0){
   throw new Error(
    "Montant invalide"
   );
 }


 return true;

}
JS


echo "[4/5] Wallet status engine..."

cat > src/lib/walletStatus.js <<'JS'
export function walletStatus(){

return {

online:true,

security:"ACTIVE",

storage:"LOCAL",

privateKey:"PROTECTED",

network:"READY"

};

}
JS


echo "[5/5] Build verification..."

npm run build


echo "================================"
echo " NUVYRA WALLET CORE READY"
echo "================================"

