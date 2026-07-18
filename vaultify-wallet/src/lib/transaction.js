import { ethers } from "ethers";
import { getProvider } from "./wallet.js";

export async function sendETH(wallet, to, amount) {
  const provider = getProvider("sepolia");

  const signer = wallet.connect(provider);

  const tx = await signer.sendTransaction({
    to,
    value: ethers.parseEther(amount)
  });

  return tx.wait();
}
