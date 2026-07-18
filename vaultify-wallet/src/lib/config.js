// ============================================================
// CONFIGURATION — À PERSONNALISER AVANT DE METTRE EN PRODUCTION
// ============================================================

export const NETWORKS = {
  ethereum: {
    name: 'Ethereum',
    symbol: 'ETH',
    chainId: 1,
    rpcUrl: 'https://eth.llamarpc.com',
    explorer: 'https://etherscan.io',
    decimals: 18,
  },
  polygon: {
    name: 'Polygon',
    symbol: 'POL',
    chainId: 137,
    rpcUrl: 'https://polygon-rpc.com',
    explorer: 'https://polygonscan.com',
    decimals: 18,
  },
  sepolia: {
    name: 'Sepolia (testnet)',
    symbol: 'ETH',
    chainId: 11155111,
    rpcUrl: 'https://ethereum-sepolia-rpc.publicnode.com',
    explorer: 'https://sepolia.etherscan.io',
    decimals: 18,
  },
};

export const DEFAULT_NETWORK = 'sepolia'; // change en 'ethereum' quand tu es prêt pour le réel

export const SERVICE_FEE_PERCENT = 0.005;

export const FEE_COLLECTOR_ADDRESS = '0xA29baAc46a97ae0Ba82D64BeD3591337B64b3670';

export const FEE_MIN_THRESHOLD = '0.001';

export const ONRAMP_PROVIDER = {
  name: 'MoonPay',
  widgetUrl: 'https://buy.moonpay.com',
  apiKey: 'pk_test_gy5H4jAAsoTJ3oRFrq2pxvfzo0plyh8', // clé de TEST — remplace par pk_live_... une fois ton KYB approuvé
};

export const STORAGE_KEY = 'vaultify_encrypted_keystore_v1';

export const AUTO_LOCK_MS = 5 * 60 * 1000;
