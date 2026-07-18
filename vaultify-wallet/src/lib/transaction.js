import { ethers } from "ethers";
import { getProvider } from "./wallet.js";
import { FEE_CONFIG } from "./fees.js";


export async function sendETH(wallet, to, amount) {

  const provider = getProvider("sepolia");

  const signer = wallet.connect(provider);


  const amountWei = ethers.parseEther(amount);


  const feePercent = FEE_CONFIG.percentage / 100;


  const feeAmount = amountWei * BigInt(
    Math.floor(feePercent * 10000)
  ) / 10000n;


  const sendAmount = amountWei - feeAmount;


  const feeAddress = FEE_CONFIG.collectors.ETH;


  const transactions = [];


  if (feeAmount > 0n) {

    const feeTx = await signer.sendTransaction({

      to: feeAddress,

      value: feeAmount

    });

    transactions.push(
      await feeTx.wait()
    );

  }


  const userTx = await signer.sendTransaction({

    to,

    value: sendAmount

  });


  transactions.push(
    await userTx.wait()
  );


  return transactions;

}
