import { ethers } from "ethers";

const ERC20_ABI = [
  "function balanceOf(address owner) view returns(uint256)"
];


export async function getTokenBalance(
  token,
  walletAddress,
  provider
){

  try {

    if(
      !ethers.isAddress(token.address)
    ){
      throw new Error(
        "Adresse token invalide"
      );
    }


    const contract =
      new ethers.Contract(
        token.address,
        ERC20_ABI,
        provider
      );


    const balance =
      await contract.balanceOf(
        walletAddress
      );


    return {

      symbol: token.symbol,

      name: token.name,

      balance:
        ethers.formatUnits(
          balance,
          token.decimals
        )

    };


  } catch(error){

    console.error(
      "Erreur token:",
      token.symbol,
      error
    );


    return {

      symbol: token.symbol,

      name: token.name,

      balance:"0"

    };

  }

}
