import { ethers } from "ethers";

const ERC20_ABI = [
  "function balanceOf(address owner) view returns (uint256)",
  "function decimals() view returns (uint8)",
  "function symbol() view returns (string)"
];

export async function getERC20Balance(
  tokenAddress,
  walletAddress,
  provider
) {
  try {

    const token = new ethers.Contract(
      tokenAddress,
      ERC20_ABI,
      provider
    );

    const [
      balance,
      decimals,
      symbol
    ] = await Promise.all([
      token.balanceOf(walletAddress),
      token.decimals(),
      token.symbol()
    ]);


    return {
      symbol,
      balance: ethers.formatUnits(
        balance,
        decimals
      )
    };


  } catch (error) {

    console.error(
      "Erreur token:",
      error
    );

    return {
      symbol: "UNKNOWN",
      balance: "0"
    };

  }
}
