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
