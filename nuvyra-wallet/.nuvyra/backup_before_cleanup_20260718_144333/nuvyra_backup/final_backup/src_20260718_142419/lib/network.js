const KEY="nuvyra_network";

export function saveNetwork(network){
localStorage.setItem(KEY,network);
}

export function getSavedNetwork(){
return localStorage.getItem(KEY) || "sepolia";
}
