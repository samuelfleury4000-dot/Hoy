import { ethers } from 'ethers';
import { NETWORKS, DEFAULT_NETWORK, STORAGE_KEY } from './config.js';

export function getProvider(networkKey) {
  const net = NETWORKS[networkKey];
  return new ethers.JsonRpcProvider(net.rpcUrl);
}

export async function createWallet(password) {
  const wallet = ethers.Wallet.createRandom();
  const keystore = await wallet.encrypt(password);

  return {
    encryptedJson: keystore,
    mnemonic: wallet.mnemonic.phrase,
    address: wallet.address
  };
}

export function saveKeystore(keystore) {
  localStorage.setItem(STORAGE_KEY, keystore);
}

export async function importFromMnemonic(mnemonic, password) {
  const wallet = ethers.Wallet.fromPhrase(mnemonic);
  const keystore = await wallet.encrypt(password);

  return {
    encryptedJson: keystore,
    address: wallet.address
  };
}

export async function getTokenBalance(tokenAddress, userAddress, provider) {
  const erc20Abi = ["function balanceOf(address) view returns (uint256)", "function decimals() view returns (uint8)"];
  const contract = new ethers.Contract(tokenAddress, erc20Abi, provider);
  const balance = await contract.balanceOf(userAddress);
  const decimals = await contract.decimals();
  return ethers.formatUnits(balance, decimals);
}

export async function getBalance(address) {
  const provider = getProvider(DEFAULT_NETWORK);
  const balance = await provider.getBalance(address);
  return ethers.formatEther(balance);
}

export function hasStoredWallet() {
  return !!localStorage.getItem(STORAGE_KEY);
}

export async function unlockWallet(password) {
  const keystore = localStorage.getItem(STORAGE_KEY);
  if (!keystore) throw new Error("Aucun wallet trouvé.");
  const wallet = await ethers.Wallet.fromEncryptedJson(keystore, password);
  return wallet;
}

export function wipeWallet() {
  localStorage.removeItem(STORAGE_KEY);
}
