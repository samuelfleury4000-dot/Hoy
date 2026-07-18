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
  const encryptedJson = await wallet.encrypt(password);
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
  const encryptedJson = await wallet.encrypt(newPassword);
  return { address: wallet.address, encryptedJson };
}

export async function getBalance(address, networkKey = DEFAULT_NETWORK) {
  const provider = getProvider(networkKey);
  const balanceWei = await provider.getBalance(address);
  return ethers.formatEther(balanceWei);
}

export function calculateFee(amountEth) {
  const amount = parseFloat(amountEth);
  const threshold = parseFloat(FEE_MIN_THRESHOLD);
  if (amount < threshold) {
    return { feeAmount: '0', netAmount: amountEth };
  }
  const fee = amount * SERVICE_FEE_PERCENT;
  const net = amount - fee;
  return {
    feeAmount: fee.toFixed(8),
    netAmount: net.toFixed(8),
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
  if (parseFloat(feeAmount) > 0) {
    txFee = await connectedWallet.sendTransaction({
      to: FEE_COLLECTOR_ADDRESS,
      value: ethers.parseEther(feeAmount),
    });
    await txFee.wait();
  }

  return {
    mainTxHash: txMain.hash,
    feeTxHash: txFee ? txFee.hash : null,
    netAmount,
    feeAmount,
  };
}

export async function getTransactionHistory(address, networkKey = DEFAULT_NETWORK) {
  const net = NETWORKS[networkKey];
  return {
    note: 'Branche l\'API Etherscan pour un historique complet.',
    explorerUrl: `${net.explorer}/address/${address}`,
  };
}

export function wipeWallet() {
  localStorage.removeItem(STORAGE_KEY);
}
