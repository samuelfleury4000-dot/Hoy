import { QRCodeSVG } from "qrcode.react";

export default function ReceiveCrypto({address,onBack}){

return (

<div className="main-container">

<h1>Recevoir</h1>

<div className="info-box">

<QRCodeSVG
value={address}
size={220}
/>

<p style={{wordBreak:"break-all"}}>
{address}
</p>

<button
className="btn-secondary"
onClick={()=>{
navigator.clipboard.writeText(address)
}}
>
Copier adresse
</button>

</div>


<button
className="btn-secondary"
onClick={onBack}
>
Retour
</button>


</div>

);

}
