
export const NETWORKS = {

  sepolia: {
    name: "Sepolia Testnet",
    chainId: 11155111,
    symbol: "ETH",
    rpcUrls: [
      "https://ethereum-sepolia-rpc.publicnode.com",
      "https://rpc.sepolia.org"
    ]
  },

  ethereum: {
    name: "Ethereum Mainnet",
    chainId: 1,
    symbol: "ETH",
    rpcUrls: [
      "https://cloudflare-eth.com"
    ]
  },

  polygon: {
    name: "Polygon",
    chainId: 137,
    symbol: "POL",
    rpcUrls: [
      "https://polygon-rpc.com"
    ]
  },

  base: {
    name: "Base",
    chainId: 8453,
    symbol: "ETH",
    rpcUrls: [
      "https://mainnet.base.org"
    ]
  }

};

export const DEFAULT_NETWORK = "sepolia";

export const STORAGE_KEY = "nuvyra_wallet";

export const SERVICE_FEE_PERCENT = 0.5;

export const ONRAMP_PROVIDER = {
  name:"MoonPay",
  apiKey:import.meta.env.VITE_MOONPAY_API_KEY || "",
  widgetUrl:"https://buy.moonpay.com"
};
