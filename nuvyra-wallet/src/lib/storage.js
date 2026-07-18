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
