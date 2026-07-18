import { SECURITY } from "../security/constants.js";
import { ethers } from "ethers";
import { NETWORKS, DEFAULT_NETWORK, STORAGE_KEY } from "./config.js";
import { getSavedNetwork } from "./network.js";
import { validatePassword } from "./walletSecurity.js";

export function getProvider(networkKey = null) {

  networkKey = networkKey || getSavedNetwork();
  const net = NETWORKS[networkKey];

  if (!net) {
    throw new Error("Réseau inconnu");
  }

  for (const rpc of net.rpcUrls) {
    try {
      return new ethers.JsonRpcProvider(rpc);
    } catch (e) {
      console.warn("RPC indisponible:", rpc);
    }
  }

  throw new Error("Aucun RPC disponible");
}

export async function createWallet(password) {
  validatePassword(password);

  const wallet = ethers.Wallet.createRandom();

  const encryptedJson = await wallet.encrypt(password);

  return {
    encryptedJson,
    mnemonic: wallet.mnemonic.phrase,
    address: wallet.address,
  };
}

export async function importFromMnemonic(mnemonic, password) {

  validatePassword(password);

  if (!mnemonic || mnemonic.trim().split(" ").length < 12) {
    throw new Error("Phrase invalide");
  }

  const wallet = ethers.Wallet.fromPhrase(mnemonic.trim());

  const encryptedJson = await wallet.encrypt(password);

  return {
    encryptedJson,
    address: wallet.address,
  };
}

export function saveKeystore(keystore) {
  localStorage.setItem(STORAGE_KEY, keystore);
}

export function hasStoredWallet() {
  return Boolean(localStorage.getItem(STORAGE_KEY));
}

export async function unlockWallet(password) {
  const keystore = localStorage.getItem(STORAGE_KEY);

  if (!keystore) {
    throw new Error("Aucun wallet trouvé");
  }

  return await ethers.Wallet.fromEncryptedJson(keystore, password);
}

export async function getBalance(address) {
  const provider = getProvider();

  const balance = await provider.getBalance(address);

  return ethers.formatEther(balance);
}

export function wipeWallet() {
  localStorage.removeItem(STORAGE_KEY);
}
