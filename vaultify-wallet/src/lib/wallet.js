import { ethers } from 'ethers';
import {
  NETWORKS,
  DEFAULT_NETWORK,
  SERVICE_FEE_PERCENT,
  FEE_COLLECTOR_ADDRESS,
  FEE_MIN_THRESHOLD,
  STORAGE_KEY,
} from './config.js';

export function getProvider(networkKey = DEFAULT_NETWORK) {
  const net = NETWORKS[networkKey];
  return new ethers.JsonRpcProvider(net.rpcUrl, net.chainId);
}

export async function createWallet(password) {
  if (!password || password.length < 8) {
    throw new Error('Le mot de passe doit contenir au moins 8 caractères.');
  }
  const wallet = ethers.Wallet.createRandom();
  // SÉCURITÉ : Maintien du callback vide pour éviter l'erreur de chiffrement
  const encryptedJson = await wallet.encrypt(password, () => {});
  return {
    address: wallet.address,
    mnemonic: wallet.mnemonic.phrase,
    encryptedJson,
  };
}

export function saveKeystore(encryptedJson) {
  localStorage.setItem(STORAGE_KEY, encryptedJson);
}

export function hasStoredWallet() {
  return !!localStorage.getItem(STORAGE_KEY);
}

export function loadEncryptedKeystore() {
  return localStorage.getItem(STORAGE_KEY);
}

export async function unlockWallet(password) {
  const encryptedJson = loadEncryptedKeystore();
  if (!encryptedJson) throw new Error('Aucun wallet trouvé sur cet appareil.');
  const wallet = await ethers.Wallet.fromEncryptedJson(encryptedJson, password);
  return wallet;
}

export async function importFromMnemonic(mnemonic, newPassword) {
  const wallet = ethers.Wallet.fromPhrase(mnemonic.trim());
  // SÉCURITÉ : Maintien du callback vide pour l'importation
  const encryptedJson = await wallet.encrypt(newPassword, () => {});
  return { address: wallet.address, encryptedJson };
}

export async function getBalance(address, networkKey = DEFAULT_NETWORK) {
  const provider = getProvider(networkKey);
  const balanceWei = await provider.getBalance(address);
  return ethers.formatEther(balanceWei);
}

// SÉCURITÉ : 100% de calculs BigInt (Wei) pour éviter toute faille de précision flottante
export function calculateFee(amountEth) {
  const amountWei = ethers.parseEther(amountEth);
  const thresholdWei = ethers.parseEther(FEE_MIN_THRESHOLD);
  
  if (amountWei < thresholdWei) {
    return { feeAmount: '0', netAmount: amountEth };
  }
  
  // Calcul via BigInt : 50n sur 10000n équivaut à 0.5% (SERVICE_FEE_PERCENT)
  const feeWei = (amountWei * 50n) / 10000n;
  const netWei = amountWei - feeWei;
  
  return {
    feeAmount: ethers.formatEther(feeWei),
    netAmount: ethers.formatEther(netWei),
  };
}

export async function sendTransaction({ wallet, toAddress, amountEth, networkKey = DEFAULT_NETWORK }) {
  if (!ethers.isAddress(toAddress)) {
    throw new Error("Adresse destinataire invalide.");
  }
  const provider = getProvider(networkKey);
  const connectedWallet = wallet.connect(provider);
  const { feeAmount, netAmount } = calculateFee(amountEth);

  const txMain = await connectedWallet.sendTransaction({
    to: toAddress,
    value: ethers.parseEther(netAmount),
  });
  await txMain.wait();

  let txFee = null;
  // SÉCURITÉ : Comparaison stricte en BigInt (0n) au lieu de parseFloat
  if (ethers.parseEther(feeAmount) > 0n) {
    txFee = await connectedWallet.sendTransaction({
      to: FEE_COLLECTOR_ADDRESS,
      value: ethers.parseEther(feeAmount),
    });
    await txFee.wait();
  }

  return { mainTxHash: txMain.hash, feeTxHash: txFee ? txFee.hash : null, netAmount, feeAmount };
}

export function wipeWallet() {
  localStorage.removeItem(STORAGE_KEY);
}

// --- CAPACITÉ MULTI-TOKEN (AJOUTÉE) ---
export async function getTokenBalance(tokenAddress, userAddress, provider) {
  const erc20Abi = [
    "function balanceOf(address) view returns (uint256)", 
    "function decimals() view returns (uint8)"
  ];
  const contract = new ethers.Contract(tokenAddress, erc20Abi, provider);
  const balance = await contract.balanceOf(userAddress);
  const decimals = await contract.decimals();
  return ethers.formatUnits(balance, decimals);
}
