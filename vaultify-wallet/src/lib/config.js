export const NETWORKS = {
  sepolia: {
    chainId: 11155111,
    rpcUrl: `https://sepolia.infura.io/v3/${import.meta.env.VITE_INFURA_ID || ''}`
  }
};

export const DEFAULT_NETWORK = 'sepolia';
export const STORAGE_KEY = 'vaultify_wallet';
export const SERVICE_FEE_PERCENT = 0.5;

export const ONRAMP_PROVIDER = {
  name: 'MoonPay',
  apiKey: import.meta.env.VITE_MOONPAY_API_KEY || '',
  widgetUrl: 'https://buy.moonpay.com'
};
