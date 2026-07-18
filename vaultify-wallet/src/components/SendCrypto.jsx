import { useState } from "react";
import { sendETH } from "../lib/transaction";

export default function SendCrypto({wallet,onBack}){

  const [address,setAddress]=useState("");
  const [amount,setAmount]=useState("");
  const [message,setMessage]=useState("");

  async function send(){

    try{

      setMessage("Transaction en cours...");

      await sendETH(
        wallet,
        address,
        amount
      );

      setMessage("Transaction envoyée !");

    }catch(e){

      setMessage(e.message);

    }

  }


  return (

    <div className="main-container">

      <h1>Envoyer ETH</h1>


      <div className="input-group">

        <label className="input-label">
          ADRESSE DESTINATION
        </label>

        <input
          className="input-field"
          onChange={e=>setAddress(e.target.value)}
          placeholder="0x..."
        />

      </div>


      <div className="input-group">

        <label className="input-label">
          MONTANT ETH
        </label>

        <input
          className="input-field"
          onChange={e=>setAmount(e.target.value)}
          placeholder="0.01"
        />

      </div>


      {message && (
        <div className="info-box">
          {message}
        </div>
      )}


      <button
        className="btn-primary"
        onClick={send}
      >
        Envoyer
      </button>


      <button
        className="btn-secondary"
        onClick={onBack}
      >
        Retour
      </button>


    </div>

  );

}
