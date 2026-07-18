import { useState, useEffect } from "react";
import { getBalance } from "../lib/wallet";
import { getCryptoPrices } from "../lib/prices";
import { openMoonPay } from "../lib/moonpay";
import PriceCard from "./PriceCard";
import SendCrypto from "./SendCrypto";

export default function Dashboard({wallet,onLogout}){

const [ethBalance,setEthBalance]=useState("0");

const [prices,setPrices]=useState({
 ethereum:{cad:0,change:0},
 bitcoin:{cad:0,change:0},
 usdc:{cad:0,change:0}
});

const [updated,setUpdated]=useState("");
const [sendMode,setSendMode]=useState(false);


async function refresh(){

try{

const balance = await getBalance(wallet.address);
setEthBalance(balance);


const data = await getCryptoPrices();

console.log("PRIX RECUS:",data);

setPrices(data);


setUpdated(
new Date().toLocaleTimeString()
);


}catch(e){

console.error("Erreur dashboard:",e);

}

}


useEffect(()=>{

refresh();

const timer=setInterval(
refresh,
60000
);

return()=>clearInterval(timer);

},[]);



if(sendMode){

return(
<SendCrypto
wallet={wallet}
onBack={()=>setSendMode(false)}
/>
);

}



return(

<div className="main-container">


<h1>
Vaultify Wallet
</h1>

<div className="info-box">
<h3>DEBUG PRIX</h3>
<p>ETH: {prices.ethereum.cad}</p>
<p>BTC: {prices.bitcoin.cad}</p>
<p>USDC: {prices.usdc.cad}</p>
</div>



<div className="info-box">

<strong>
Adresse du wallet
</strong>

<p style={{wordBreak:"break-all"}}>
{wallet.address}
</p>

</div>



<div className="info-box">

<h3>
Portfolio ETH
</h3>


<p>
Balance:
{" "}
{Number(ethBalance).toFixed(6)}
ETH
</p>


<p>
Valeur:
{" "}
{(
Number(ethBalance) *
Number(prices.ethereum.cad)
).toLocaleString("fr-CA",
{
minimumFractionDigits:2,
maximumFractionDigits:2
})}
CAD
</p>


<small>
Mise à jour: {updated}
</small>


</div>



<PriceCard
name="Ethereum"
amount={ethBalance}
price={prices.ethereum.cad}
change={prices.ethereum.change}
/>


<PriceCard
name="Bitcoin"
amount="0"
price={prices.bitcoin.cad}
change={prices.bitcoin.change}
/>


<PriceCard
name="USDC"
amount="0"
price={prices.usdc.cad}
change={prices.usdc.change}
/>



<button
className="btn-primary"
onClick={()=>openMoonPay(wallet.address,"ETH")}
>
Acheter crypto
</button>


<button
className="btn-primary"
onClick={()=>setSendMode(true)}
>
Envoyer ETH
</button>


<button
className="btn-secondary"
onClick={refresh}
>
Actualiser prix
</button>


<button
className="btn-secondary"
onClick={onLogout}
>
Déconnexion
</button>


</div>

);

}
