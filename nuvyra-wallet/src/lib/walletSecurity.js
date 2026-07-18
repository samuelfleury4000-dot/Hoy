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
