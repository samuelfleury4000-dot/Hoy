import { ethers } from "ethers";
import { getProvider } from "./wallet.js";
import { FEE_CONFIG } from "./fees.js";


export async function estimateETHFee(){

  const provider =
    getProvider("sepolia");


  const fee =
    await provider.getFeeData();


  return {
    gasPrice:
      fee.gasPrice
        ? ethers.formatUnits(
            fee.gasPrice,
            "gwei"
          )
        : "0"
  };

}



export async function sendETH(
  wallet,
  to,
  amount
){

  if(!ethers.isAddress(to)){
    throw new Error(
      "Adresse destination invalide"
    );
  }


  if(
    !amount ||
    Number(amount)<=0
  ){
    throw new Error(
      "Montant invalide"
    );
  }


  const provider =
    getProvider("sepolia");


  const balance =
    await provider.getBalance(
      wallet.address
    );


  const value =
    ethers.parseEther(amount);


  if(value >= balance){

    throw new Error(
      "Solde ETH insuffisant"
    );

  }


  const signer =
    wallet.connect(provider);


  const tx =
    await signer.sendTransaction({

      to,

      value

    });


  return await tx.wait();

}
