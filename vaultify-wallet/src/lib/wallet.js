import { ethers } from "ethers";
import { NETWORKS, DEFAULT_NETWORK, STORAGE_KEY } from "./config.js";

export function getProvider(networkKey){

const net = NETWORKS[networkKey];

return new ethers.JsonRpcProvider(net.rpcUrl);

}


export async function createWallet(password){

const wallet = ethers.Wallet.createRandom();

const encryptedJson = await wallet.encrypt(password);

return {
encryptedJson,
mnemonic:wallet.mnemonic.phrase,
address:wallet.address
};

}


export function saveKeystore(data){

localStorage.setItem(
STORAGE_KEY,
data
);

}


export async function importFromMnemonic(mnemonic, password){

const wallet = ethers.Wallet.fromPhrase(mnemonic);

const encryptedJson = await wallet.encrypt(password);

return {
  encryptedJson,
  address: wallet.address
};

}


export function hasStoredWallet(){

return Boolean(
localStorage.getItem(STORAGE_KEY)
);

}


export async function unlockWallet(password){

const encrypted =
localStorage.getItem(STORAGE_KEY);

if(!encrypted)
throw new Error("Wallet absent");

return await ethers.Wallet.fromEncryptedJson(
encrypted,
password
);

}


export async function getBalance(address){

try{

const provider=getProvider(DEFAULT_NETWORK);

const balance =
await provider.getBalance(address);

return ethers.formatEther(balance);

}catch(e){

console.error("Balance erreur",e);

return "0";

}

}


export function wipeWallet(){

localStorage.removeItem(STORAGE_KEY);

}
