import { ethers } from "ethers";
import { getProvider } from "./wallet.js";


export async function estimateETHFee(to, amount){

  const provider = getProvider();

  const gasPrice = await provider.getFeeData();

  const gasLimit = await provider.estimateGas({
    to,
    value: ethers.parseEther(amount)
  });


  const price =
    gasPrice.gasPrice || 0;


  const fee =
    gasLimit * price;


  return {
    gasLimit: gasLimit.toString(),
    gasPrice: ethers.formatUnits(price,"gwei"),
    feeETH: ethers.formatEther(fee)
  };

}



export async function sendETH(
  wallet,
  to,
  amount
){

  if(!ethers.isAddress(to)){
    throw new Error("Adresse destination invalide");
  }


  if(!amount || Number(amount)<=0){
    throw new Error("Montant invalide");
  }


  const provider=getProvider("sepolia");


  const balance =
    await provider.getBalance(wallet.address);


  const value =
    ethers.parseEther(amount);


  const fee =
    await estimateETHFee(to,amount);


  const total =
    value +
    ethers.parseEther(fee.feeETH);


  if(total >= balance){

    throw new Error(
      "Solde insuffisant avec les frais réseau"
    );

  }


  const signer =
    wallet.connect(provider);


  const tx =
    await signer.sendTransaction({

      to,
      value,
      gasLimit:fee.gasLimit

    });


  const receipt =
    await tx.wait();


  return {
    hash:tx.hash,
    receipt
  };

}
