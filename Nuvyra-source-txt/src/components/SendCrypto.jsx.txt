import { useState } from "react";
import { ethers } from "ethers";
import { sendETH } from "../lib/transaction";


export default function SendCrypto({wallet,onBack}){

  const [address,setAddress]=useState("");
  const [amount,setAmount]=useState("");
  const [message,setMessage]=useState("");
  const [confirm,setConfirm]=useState(false);


  async function send(){

    try{

      setMessage(
        "Transaction en cours..."
      );


      await sendETH(
        wallet,
        address,
        amount
      );


      setMessage(
        "Transaction envoyée !"
      );


    }catch(e){

      setMessage(
        e.message
      );

    }

  }


  function preview(){

    if(!ethers.isAddress(address)){
      setMessage(
        "Adresse invalide"
      );
      return;
    }


    if(!amount || Number(amount)<=0){

      setMessage(
        "Montant invalide"
      );

      return;

    }


    setConfirm(true);

  }



  return (

    <div className="main-container">

      <h1>
        Envoyer ETH
      </h1>


      {!confirm ? (

        <>

        <div className="input-group">

          <label className="input-label">
            ADRESSE DESTINATION
          </label>

          <input
            className="input-field"
            value={address}
            onChange={
              e=>setAddress(e.target.value)
            }
            placeholder="0x..."
          />

        </div>



        <div className="input-group">

          <label className="input-label">
            MONTANT ETH
          </label>

          <input
            className="input-field"
            value={amount}
            onChange={
              e=>setAmount(e.target.value)
            }
            placeholder="0.01"
          />

        </div>


        <button
          className="btn-primary"
          onClick={preview}
        >
          Vérifier la transaction
        </button>


        </>

      ) : (

        <div className="info-box">

          <h3>
            Confirmation
          </h3>


          <p>
            Destination :
          </p>

          <p style={{
            wordBreak:"break-all"
          }}>
            {address}
          </p>


          <p>
            Montant :
            {" "}
            {amount}
            {" ETH"}
          </p>


          <button
            className="btn-primary"
            onClick={send}
          >
            Confirmer l'envoi
          </button>


          <button
            className="btn-secondary"
            onClick={()=>{
              setConfirm(false)
            }}
          >
            Modifier
          </button>


        </div>

      )}


      {message && (
        <div className="info-box">
          {message}
        </div>
      )}


      <button
        className="btn-secondary"
        onClick={onBack}
      >
        Retour
      </button>


    </div>

  );

}
