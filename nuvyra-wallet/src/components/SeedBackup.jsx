import { useState } from "react";

export default function SeedBackup({seed,onConfirm}){

  const [visible,setVisible]=useState(false);
  const [copied,setCopied]=useState(false);
  const [checked,setChecked]=useState(false);


  async function copy(){

    await navigator.clipboard.writeText(seed);

    setCopied(true);

    setTimeout(()=>setCopied(false),2000);

  }


  return (

    <div className="main-container">

      <h1>Sauvegarde requise</h1>

      <div className="error-box">
        Cette phrase est la seule sauvegarde de ton wallet.
        Toute personne qui la possède contrôle les fonds.
      </div>


      <div className="info-box">

        {visible ? seed : "•••• •••• •••• •••• •••• •••• •••• •••• •••• •••• •••• ••••"}

      </div>


      <button
        className="btn-secondary"
        onClick={()=>setVisible(!visible)}
      >
        {visible ? "Masquer" : "Afficher la phrase"}
      </button>


      <button
        className="btn-secondary"
        onClick={copy}
      >
        {copied ? "Copié ✓" : "Copier"}
      </button>


      <label style={{
        display:"block",
        margin:"1.5rem 0"
      }}>

        <input
          type="checkbox"
          checked={checked}
          onChange={e=>setChecked(e.target.checked)}
        />

        {" "}
        J'ai sauvegardé ma phrase secrète

      </label>


      <button
        className="btn-primary"
        disabled={!checked}
        onClick={onConfirm}
      >
        Continuer
      </button>

    </div>

  );

}
