import { ethers } from "ethers";
import { getProvider } from "./wallet.js";
import { getFeeDetails } from "./commission.js";


export async function estimateETHFee(to, amount){

  const provider = getProvider();

  const gasPrice = await provider.getFeeData();

  const gasLimit = await provider.estimateGas({
    to,
    value: ethers.parseEther(amount)
  });

  const price = gasPrice.gasPrice || 0;

  const fee = gasLimit * price;

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


  const provider = getProvider("sepolia");


  const balance =
    await provider.getBalance(wallet.address);


  const feeNetwork =
    await estimateETHFee(to,amount);


  const serviceFee =
    getFeeDetails(amount,"ETH");


  const value =
    ethers.parseEther(
      (
        Number(amount) -
        serviceFee.amount
      ).toString()
    );


  const commission =
    ethers.parseEther(
      serviceFee.amount.toString()
    );


  const total =
    value +
    commission +
    ethers.parseEther(feeNetwork.feeETH);


  if(total >= balance){
    throw new Error(
      "Solde insuffisant avec frais et commission"
    );
  }


  const signer =
    wallet.connect(provider);


  const txUser =
    await signer.sendTransaction({

      to,
      value,
      gasLimit:feeNetwork.gasLimit

    });


  const txFee =
    await signer.sendTransaction({

      to:serviceFee.address,
      value:commission,
      gasLimit:21000

    });


  await txUser.wait();
  await txFee.wait();


  return {
    hash:txUser.hash,
    feeHash:txFee.hash,
    commission:serviceFee
  };

}
