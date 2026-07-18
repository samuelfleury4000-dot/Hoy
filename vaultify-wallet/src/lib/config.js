export const NETWORKS = {

  sepolia: {
    name: "Sepolia Testnet",
    chainId: 11155111,
    symbol: "ETH",
    rpcUrl: `https://sepolia.infura.io/v3/${import.meta.env.VITE_INFURA_ID || ''}`
  },


  ethereum: {
    name: "Ethereum Mainnet",
    chainId: 1,
    symbol: "ETH",
    rpcUrl: `https://mainnet.infura.io/v3/${import.meta.env.VITE_INFURA_ID || ''}`
  },


  polygon: {
    name: "Polygon",
    chainId: 137,
    symbol: "POL",
    rpcUrl: `https://polygon-mainnet.infura.io/v3/${import.meta.env.VITE_INFURA_ID || ''}`
  },


  base: {
    name: "Base",
    chainId: 8453,
    symbol: "ETH",
    rpcUrl: `https://base-mainnet.infura.io/v3/${import.meta.env.VITE_INFURA_ID || ''}`
  }

};


export const DEFAULT_NETWORK = "sepolia";


export const STORAGE_KEY = "vaultify_wallet";


export const SERVICE_FEE_PERCENT = 0.5;


export const ONRAMP_PROVIDER = {

  name: "MoonPay",

  apiKey:
    import.meta.env.VITE_MOONPAY_API_KEY || "",

  widgetUrl:
    "https://buy.moonpay.com"

};
