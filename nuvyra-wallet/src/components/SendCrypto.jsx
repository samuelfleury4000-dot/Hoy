import { useState } from "react";
import { ethers } from "ethers";
import { sendETH, estimateETHFee } from "../lib/transaction";
import { getFeeDetails } from "../lib/commission";


export default function SendCrypto({wallet,onBack}){

const [address,setAddress]=useState("");
const [amount,setAmount]=useState("");
const [message,setMessage]=useState("");
const [confirm,setConfirm]=useState(false);
const [fee,setFee]=useState(null);
const [sending,setSending]=useState(false);
const [hash,setHash]=useState("");
const [error,setError]=useState("");



async function preview(){

try{

if(!ethers.isAddress(address)){
throw new Error("Adresse invalide");
}

if(!amount || Number(amount)<=0){
throw new Error("Montant invalide");
}


const estimated =
await estimateETHFee(address,amount);


setFee({
  ...estimated,
  service: getFeeDetails(amount, "ETH")
});
setConfirm(true);


}catch(e){

setMessage(e.message);

}

}



async function send(){

if(sending) return;

try{

setSending(true);

setMessage("Transaction en cours...");


const result =
await sendETH(
wallet,
address,
amount
);


setHash(result.hash);

setMessage(
"Transaction confirmée"
);


}catch(e){

setMessage(e.message);

}finally{

setSending(false);

}

}



return (

<div className="main-container">

<h1>Envoyer ETH</h1>


{!confirm ? (

<>

<input
className="input-field"
placeholder="0x..."
value={address}
onChange={e=>setAddress(e.target.value)}
/>


<input
className="input-field"
placeholder="0.01"
value={amount}
onChange={e=>setAmount(e.target.value)}
/>


<button
className="btn-primary"
onClick={preview}
>
Vérifier
</button>

</>

):(


<div className="info-box">

<p>
Destination :
</p>

<p style={{wordBreak:"break-all"}}>
{address}
</p>

<p>
Montant : {amount} ETH
</p>


{fee && (

<>
<p>
Frais réseau :
{fee.feeETH} ETH
</p>

<p>
Commission Nuvyra :
{fee.service.amount} ETH ({fee.service.percent}%)
</p>

<p style={{wordBreak:"break-all"}}>
Adresse commission :
{fee.service.address}
</p>
</>

)}


<button
className="btn-primary"
disabled={sending}
onClick={send}
>
{sending ? "Envoi..." : "Confirmer"}
</button>


</div>

)}


{hash && (

<div className="info-box">

Transaction :

<a
href={`https://sepolia.etherscan.io/tx/${hash}`}
target="_blank"
>
Voir sur Etherscan
</a>

</div>

)}


{message &&

<div className="info-box">
{message}
</div>
}


<button
className="btn-secondary"
onClick={onBack}
>
Retour
</button>


</div>

);

}
